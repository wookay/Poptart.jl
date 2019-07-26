# module Poptart.Desktop.Windows

using UnicodePlots: extend_limits
using Printf: @sprintf
using SparseArrays: sparse

function _get_item_props(item, name::Symbol, default)
    get(item.props, name, default)
end

# CImGui.Button
function imgui_control_item(imctx::Ptr, item::Button)
    if CImGui.Button(item.title)
        block = _get_item_props(item, :block, nothing)
        block !== nothing && block()
        @async Mouse.leftClick(item)
    end
end

# CImGui.SliderInt, CImGui.SliderFloat
function _imgui_slider_item(item::Slider, value, f, refvalue::Ref)
    min = minimum(item.range)
    max = maximum(item.range)
    if f(item.label, refvalue, min, max)
        typ = typeof(value)
        item.value = typ(refvalue[])
        block = _get_item_props(item, :block, nothing)
        block !== nothing && block()
        @async Mouse.leftClick(item)
    end
end

function _imgui_slider_item(item::Slider, value::Integer)
    f = CImGui.SliderInt
    refvalue = Ref{Cint}(value)
    _imgui_slider_item(item, value, f, refvalue)
end

function _imgui_slider_item(item::Slider, value::AbstractFloat)
    f = CImGui.SliderFloat
    refvalue = Ref{Cfloat}(value)
    _imgui_slider_item(item, value, f, refvalue)
end

function imgui_control_item(imctx::Ptr, item::Slider)
    _imgui_slider_item(item, item.value)
end

function imgui_control_item(imctx::Ptr, item::Label)
    CImGui.igText(item.text)
end

function imgui_control_item(imctx::Ptr, item::Canvas)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    for drawing in item.items
        imgui_drawing_item(draw_list, window_pos, drawing, drawing.element)
    end
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

function renderframe(draw_list, p_min::ImVec2, p_max::ImVec2, fill_col::ImU32, border::Bool, rounding::Cfloat)
    CImGui.AddRectFilled(draw_list, p_min, p_max, fill_col, rounding)
    border_size = 0
    if border_size > 0
        CImGui.AddRect(draw_list, p_min+ImVec2(1,1), p_max+ImVec2(1,1), CImGui.GetColorU32(CImGui.ImGuiCol_BorderShadow), rounding, CImGui.ImDrawCornerFlags_All, border_size);
        CImGui.AddRect(draw_list, p_min, p_max, CImGui.GetColorU32(CImGui.ImGuiCol_Border), rounding, CImGui.ImDrawCornerFlags_All, border_size)
    end
end

function imgui_control_item(imctx::Ptr, item::ScatterPlot)
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
    renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    radius = 4
    color_normal = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines)
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    num_segments = 8
    X, Y = item.x, item.y
    if haskey(item.props, :scale)
        scale = item.scale
        min_x, max_x = scale.x
        min_y, max_y = scale.y
    else
        xlim = (0, 0)
        ylim = (0, 0)
        min_x, max_x = extend_limits(X, xlim)
        min_y, max_y = extend_limits(Y, ylim)
    end
    locate = (x = (graph_size.x - 2frame_padding.x) / (max_x - min_x),
              y = (graph_size.y - 2frame_padding.y) / (max_y - min_y))
    for (x, y) in zip(X, Y)
        pos = ((x - min_x) * locate.x + frame_padding.x, (y - min_y) * locate.y + frame_padding.y)
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
    label = _get_item_props(item, :label, "")
    CImGui.igText(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_control_item(imctx::Ptr, item::Spy)
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
    renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    color_positive = RGB(0.3, 0.5, 0.58)
    color_negative = RGB(0.32, 0.1, 0.1)
    rounding = 0
    A = item.A
    (rows, cols) = size(A)
    if rows > cols
        cellsize = (graph_size.y - 2frame_padding.y) / rows
        x = graph_size.x - cellsize*cols - 2frame_padding.x
        halfx = x > 0 ? x/2 : 0
        halfy = 0
    else
        cellsize = (graph_size.x - 2frame_padding.x) / cols
        y = graph_size.y - cellsize*rows - 2frame_padding.y
        halfx = 0
        halfy = y > 0 ? y/2 : 0
    end
    cellsize_pad = cellsize < 3 ? 3 : 0
    for (ind, v) in pairs(sparse(A))
        if !iszero(v)
            (i, j) = ind.I
            pos = ((j-1) * cellsize + frame_padding.x + halfx, (i-1) * cellsize + frame_padding.y + halfy)
            p_min = imgui_offset_vec2(window_pos, pos)
            p_max = imgui_offset_vec2(window_pos, pos .+ cellsize .+ cellsize_pad)
            if rect_contains_pos(ImVec4(p_min, p_max), mouse_pos)
                CImGui.BeginTooltip()
                CImGui.Text(string("[", i, ", ", j, "] = ", v))
                CImGui.EndTooltip()
                color = color_hovered
            else
                if v > 0
                    color = imgui_color(RGBA(color_positive, v))
                else
                    color = imgui_color(RGBA(color_negative, -v))
                end
            end
            CImGui.AddRectFilled(draw_list, p_min, p_max, color, rounding)
        end
    end
    CImGui.SetCursorScreenPos(window_pos + ImVec2(graph_size.x + 4, 3))
    label = _get_item_props(item, :label, "")
    CImGui.igText(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_control_item(imctx::Ptr, item::BarPlot)
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    default_size = (width=CImGui.CalcItemWidth(), height=150)
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
    renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    color_positive = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines)
    color_negative = imgui_color(RGBA(0.4, 0.1, 0.15, 0.9))
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    rounding = 0
    values = item.values
    len = length(values)
    captions = _get_item_props(item, :captions, fill("", len))
    barsize = (graph_size.y - 2frame_padding.y) / len
    barsize_pad = barsize < 5 ? 0 : 3
    textsize = 80
    (min_x, max_x) = _get_item_props(item, :scale, (minimum(values) < 0 ? -1 : 0, 1))
    locate = (x = (graph_size.x - 2frame_padding.x - textsize) / (max_x - min_x), )
    has_negative = min_x < 0
    offsetx = has_negative ? locate.x * (max_x - min_x) / 2 : 0
    for (idx, value) in enumerate(values)
        caption = captions[idx]
        barwidth = locate.x * value
        pos = (offsetx + textsize + frame_padding.x, (idx - 1) * barsize + frame_padding.y + barsize_pad)
        if value < 0
            p_min = imgui_offset_vec2(window_pos, pos .+ (barwidth, 0))
            p_max = imgui_offset_vec2(window_pos, pos .+ (0, barsize .- barsize_pad))
        else
            p_min = imgui_offset_vec2(window_pos, pos)
            p_max = imgui_offset_vec2(window_pos, pos .+ (barwidth, barsize .- barsize_pad))
        end
        captionpos = imgui_offset_vec2(window_pos, (textsize + frame_padding.x, pos[2])) + ImVec2(-textsize, -barsize_pad)
        if rect_contains_pos(ImVec4(captionpos, p_max), mouse_pos)
            CImGui.BeginTooltip()
            CImGui.Text(string(caption, "\n", value))
            CImGui.EndTooltip()
            color = color_hovered
            color_caption = color_hovered
        else
            color = value > 0 ? color_positive : color_negative
            color_caption = color_positive
        end
        CImGui.SetCursorScreenPos(captionpos)
        CImGui.igTextColored(color_caption, caption)
        CImGui.AddRectFilled(draw_list, p_min, p_max, color, rounding)
    end
    CImGui.SetCursorScreenPos(window_pos + ImVec2(graph_size.x + 4, 3))
    label = _get_item_props(item, :label, "")
    CImGui.igText(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

# CImGui.PlotLines
function imgui_control_item(imctx::Ptr, item::LinePlot)
    label = _get_item_props(item, :label, "")
    values = Cfloat.(item.values)
    overlay_text = _get_item_props(item, :overlay_text, C_NULL)
    scale = _get_item_scale(item)
    graph_size = _get_item_frame_size(item)
    CImGui.PlotLines(label, values, length(values), Cint(0), overlay_text, scale.min, scale.max, graph_size)
end

# CImGui.PlotHistogram
function imgui_control_item(imctx::Ptr, item::Histogram)
    label = _get_item_props(item, :label, "")
    values = Cfloat.(item.values)
    overlay_text = _get_item_props(item, :overlay_text, C_NULL)
    scale = _get_item_scale(item)
    graph_size = _get_item_frame_size(item)
    CImGui.PlotHistogram(label, values, length(values), Cint(0), overlay_text, scale.min, scale.max, graph_size)
end

# layouts
function imgui_control_item(imctx::Ptr, item::Group)
    CImGui.BeginGroup()
    for el in item.items
        if el isa UIControl
            f = imgui_control_item
        elseif el isa LayoutElement
            f = imgui_layout_item
        end
        f(imctx, el)
    end
    CImGui.EndGroup()
end

function imgui_layout_item(imctx::Ptr, item::Separator)
    CImGui.Separator()
end

function imgui_layout_item(imctx::Ptr, item::SameLine)
    CImGui.SameLine()
end

function imgui_layout_item(imctx::Ptr, item::NewLine)
    CImGui.NewLine()
end

function imgui_layout_item(imctx::Ptr, item::Spacing)
    CImGui.Spacing()
end

# menus
using Jive
function imgui_control_item(imctx::Ptr, item::MenuBar)
    if CImGui.BeginMenuBar()
        for menu in item.menus
            imgui_control_item(imctx, menu)
        end
        CImGui.EndMenuBar()
    end
end

function imgui_control_item(imctx::Ptr, item::Menu)
    if CImGui.BeginMenu(item.title)
        for menuitem in item.items
            imgui_control_item(imctx, menuitem)
        end
        CImGui.EndMenu()
    end
end

function imgui_control_item(imctx::Ptr, item::MenuItem)
    shortcut = _get_item_props(item, :shortcut, C_NULL)
    selected = _get_item_props(item, :selected, false)
    enabled = _get_item_props(item, :enabled, true)
    ref_selected = Ref(selected)
    if CImGui.MenuItem(item.title, shortcut, ref_selected, enabled)
        block = _get_item_props(item, :block, nothing)
        block !== nothing && block()
    end
end

using Jive # @onlyonce
function imgui_control_item(imctx::Ptr, item::Any)
    @onlyonce begin
        @info "not implemented" item
    end
end

function remove_imgui_control_item(item::Any)
end

# module Poptart.Desktop.Windows
