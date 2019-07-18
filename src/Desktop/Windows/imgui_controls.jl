# module Poptart.Desktop.Windows

using UnicodePlots: extend_limits
using Printf: @sprintf

function imgui_item(block, imctx::Ptr, item::Button)
    CImGui.Button(item.title) && @async Mouse.leftClick(item)
end

struct UnsupportedError <: Exception
    msg
end

function imgui_item(block, imctx::Ptr, item::Slider)
    typ = typeof(item.value)
    if typ isa Type{<:Integer}
        f = CImGui.SliderInt
        refvalue = Ref{Cint}(item.value)
    elseif typ isa Type{<:AbstractFloat}
        f = CImGui.SliderFloat
        refvalue = Ref{Cfloat}(item.value)
    else
        throw(UnsupportedError("got unsupported type $typ"))
    end
    label = item.label
    min = minimum(item.range)
    max = maximum(item.range)
    if f(label, refvalue, min, max)
        item.value = typ(refvalue[])
        @async Mouse.leftClick(item)
    end
end

function imgui_item(block, imctx::Ptr, item::Label)
    CImGui.LabelText(item.label, item.text)
end

function imgui_item(block, imctx::Ptr, item::Canvas)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    for drawing in item.items
        imgui_drawing_item(imctx, draw_list, window_pos, drawing, drawing.element)
    end
end

function _get_item_property(item, name::Symbol, default)
    get(item.props, name, default)
end

function _get_item_scale(item)::NamedTuple{(:min, :max)}
    if haskey(item.props, :scale)
        item.scale
    else
        (min=0, max=1)
    end
end

function _get_item_frame_size(item)::ImVec2
    if haskey(item.props, :frame)
        width = get(item.frame, :width, 0)
        height = get(item.frame, :height, 0)
    else
        width, height = (0, 0)
    end
    ImVec2(width, height)
end

function rect_contains_pos(rect::ImVec4, p::ImVec2)
    p.x >= ImVec2(rect, min).x && p.y >= ImVec2(rect, min).y && p.x < ImVec2(rect, max).x && p.y < ImVec2(rect, max).y
end

function RenderFrame(draw_list, p_min::ImVec2, p_max::ImVec2, fill_col::ImU32, border::Bool, rounding::Cfloat)
    CImGui.AddRectFilled(draw_list, p_min, p_max, fill_col, rounding)
    border_size = 0
    if border_size > 0
        CImGui.AddRect(draw_list, p_min+ImVec2(1,1), p_max+ImVec2(1,1), CImGui.GetColorU32(CImGui.ImGuiCol_BorderShadow), rounding, CImGui.ImDrawCornerFlags_All, border_size);
        CImGui.AddRect(draw_list, p_min, p_max, CImGui.GetColorU32(CImGui.ImGuiCol_Border), rounding, CImGui.ImDrawCornerFlags_All, border_size)
    end
end

function imgui_item(block, imctx::Ptr, item::ScatterPlot)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    default_size = (width=CImGui.CalcItemWidth(), height=50)
    if haskey(item.props, :frame)
        w = get(item.frame, :width, default_size.width)
        h = get(item.frame, :height, default_size.height)
        graph_size = ImVec2(w, h)
    else
        graph_size = ImVec2(default_size.width, default_size.height)
    end
    frame_rounding = Cfloat(1)
    frame_padding = (x=7, y=7)
    frame_bb = CImGui.ImVec4(window_pos, window_pos + ImVec2(graph_size.x, graph_size.y))
    RenderFrame(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    radius = 3
    color_normal = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines)
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    num_segments = 8
    X, Y = item.x, item.y
    xlim = (0, 0)
    ylim = (0, 0)
    min_x, max_x = extend_limits(X, xlim)
    min_y, max_y = extend_limits(Y, ylim)
    scale = (x = (graph_size.x - 2frame_padding.x) / (max_x - min_x),
             y = (graph_size.y - 2frame_padding.y) / (max_y - min_y))
    for (x, y) in zip(X, Y)
        pos = ((x - min_x) * scale.x + frame_padding.x, (y - min_y) * scale.y + frame_padding.y)
        center = imgui_offset_vec2(window_pos, pos)
        if rect_contains_pos(ImVec4(center - radius, center + radius), mouse_pos)
            CImGui.BeginTooltip()
            CImGui.Text(string("x: ", @sprintf("%.2f", x), ", y: ", @sprintf("%.2f", y)))
            CImGui.EndTooltip()
            color = color_hovered
        else
            color = color_normal
        end
        CImGui.AddCircleFilled(draw_list, center, radius, color, num_segments)
    end
    CImGui.SetCursorScreenPos(window_pos + ImVec2(graph_size.x + 4, 3))
    CImGui.igText(item.label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_item(block, imctx::Ptr, item::LinePlot)
    label = _get_item_property(item, :label, "")
    values = Cfloat.(item.values)
    overlay_text = _get_item_property(item, :overlay_text, C_NULL)
    scale = _get_item_scale(item)
    graph_size = _get_item_frame_size(item)
    CImGui.PlotLines(label, values, length(values), Cint(0), overlay_text, scale.min, scale.max, graph_size)
end

function imgui_item(block, imctx::Ptr, item::Histogram)
    label = _get_item_property(item, :label, "")
    values = Cfloat.(item.values)
    overlay_text = _get_item_property(item, :overlay_text, C_NULL)
    scale = _get_item_scale(item)
    graph_size = _get_item_frame_size(item)
    CImGui.PlotHistogram(label, values, length(values), Cint(0), overlay_text, scale.min, scale.max, graph_size)
end

using Jive # @onlyonce
function imgui_item(block, imctx::Ptr, item::Any)
    @onlyonce begin
        @info "not implemented" item
    end
end

function remove_imgui_item(item::Any)
end

# module Poptart.Desktop.Windows
