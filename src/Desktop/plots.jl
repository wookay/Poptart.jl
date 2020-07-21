# module Poptart.Desktop

using UnicodePlots: extend_limits
using Printf: @sprintf
using SparseArrays: sparse

"""
    ScatterPlot(; x::AbstractVector, y::AbstractVector, [label::String], [scale::NamedTuple{(:x, :y)}], [frame])
"""
@kwdef mutable struct ScatterPlot <: UIControl
    x::AbstractVector
    y::AbstractVector
    label::String = ""
    scale::Union{Nothing,NamedTuple{(:x, :y)}} = nothing
    frame::Union{Nothing,NamedTuple{(:width, :height)}} = nothing
end

"""
    Spy(; A::AbstractMatrix, [label::String], [frame])
"""
@kwdef mutable struct Spy <: UIControl
    A::AbstractMatrix
    label::String = ""
    frame::Union{Nothing,NamedTuple{(:width, :height)}} = nothing
end

"""
    BarPlot(; values::Vector{Number}, [captions::Vector{String}], [label::String], [scale::NamedTuple{(:min_x,:max_x)}], [frame])
"""
@kwdef mutable struct BarPlot <: UIControl
    values::Vector{Number}
    captions::Vector{String}
    label::String = ""
    scale::Union{Nothing,NamedTuple{(:min_x,:max_x)}} = nothing
    frame::Union{Nothing,NamedTuple{(:width, :height)}} = nothing
end

"""
    LinePlot(; values::AbstractVector, [label::String], [scale::NamedTuple{(:min, :max)}], [color::RGBA], [frame])
"""
@kwdef mutable struct LinePlot <: UIControl
    values::AbstractVector
    label::String = ""
    scale::NamedTuple{(:min, :max)} = (min=0, max=1)
    color::Union{Nothing,RGBA} = nothing
    frame::Union{Nothing,NamedTuple{(:width, :height)}} = nothing
end

"""
    MultiLinePlot(; items::Vector{LinePlot}, [label::String], [scale::NamedTuple{(:min, :max)}], [frame])
"""
@kwdef mutable struct MultiLinePlot <: UIControl
    items::Vector{LinePlot}
    label::String = ""
    scale::NamedTuple{(:min, :max)} = (min=0, max=1)
    frame::Union{Nothing,NamedTuple{(:width, :height)}} = nothing
end

"""
    Histogram(; values::AbstractVector, [label::String], [scale::NamedTuple{(:min, :max)}], [frame])
"""
@kwdef mutable struct Histogram<: UIControl
    values::AbstractVector
    label::String = ""
    scale::NamedTuple{(:min, :max)} = (min=0, max=1)
    frame::Union{Nothing,NamedTuple{(:width, :height)}} = nothing
    overlay_text::Union{Ptr{Nothing},String} = C_NULL
end


function get_prop(item::UIControl, name::Symbol)
    getfield(item, name)
end

function get_prop_frame_size(item::UIControl, default)::ImVec2
    frame = something(item.frame, default)
    ImVec2(frame.width, frame.height)
end

function get_prop_scale(item::UIControl, default=(min=0, max=1))::NamedTuple
    something(item.scale, default)
end

function _renderframe(draw_list, p_min::ImVec2, p_max::ImVec2, fill_col::ImU32, border::Bool, rounding::Cfloat)
    CImGui.AddRectFilled(draw_list, p_min, p_max, fill_col, rounding)
    border_size = 0
    if border_size > 0
        CImGui.AddRect(draw_list, p_min+ImVec2(1,1), p_max+ImVec2(1,1), CImGui.GetColorU32(CImGui.ImGuiCol_BorderShadow), rounding, CImGui.ImDrawCornerFlags_All, border_size);
        CImGui.AddRect(draw_list, p_min, p_max, CImGui.GetColorU32(CImGui.ImGuiCol_Border), rounding, CImGui.ImDrawCornerFlags_All, border_size)
    end
end

function imgui_control_item(imctx::Ptr, item::ScatterPlot)
    X, Y = item.x, item.y # :x :y
    label = get_prop(item, :label)
    scale = item.scale
    if scale === nothing
        xlim = (0, 0)
        ylim = (0, 0)
        min_x, max_x = extend_limits(X, xlim)
        min_y, max_y = extend_limits(Y, ylim)
    else
        min_x, max_x = scale.x
        min_y, max_y = scale.y
    end
    graph_size = get_prop_frame_size(item, (width=CImGui.CalcItemWidth(), height=50)) # :frame
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    frame_rounding = Cfloat(1)
    frame_padding = (x=7, y=7)
    frame_bb = CImGui.ImVec4(window_pos, window_pos + ImVec2(graph_size.x, graph_size.y))
    _renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    radius = 4
    color_normal = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines)
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    num_segments = 8
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
    CImGui.Text(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_control_item(imctx::Ptr, item::Spy)
    A = item.A # :A
    label = get_prop(item, :label)
    graph_size = get_prop_frame_size(item, (width=CImGui.CalcItemWidth(), height=50)) # :frame
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    frame_rounding = Cfloat(1)
    frame_padding = (x=7, y=7)
    frame_bb = CImGui.ImVec4(window_pos, window_pos + ImVec2(graph_size.x, graph_size.y))
    _renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    color_positive = RGB(0.3, 0.5, 0.58)
    color_negative = RGB(0.32, 0.1, 0.1)
    rounding = 0
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
    CImGui.Text(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_control_item(imctx::Ptr, item::BarPlot)
    values = item.values # :values
    len = length(values)
    captions = get_prop(item, :captions)
    if item.scale === nothing
        (min_x, max_x) = (min_x=minimum(values) < 0 ? -1 : 0, max_x=1) # :scale
    else
        (min_x, max_x) = item.scale
    end
    label = get_prop(item, :label)
    graph_size = get_prop_frame_size(item, (width=CImGui.CalcItemWidth(), height=150)) # :frame
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    frame_rounding = Cfloat(1)
    frame_padding = (x=7, y=7)
    frame_bb = CImGui.ImVec4(window_pos, window_pos + ImVec2(graph_size.x, graph_size.y))
    _renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)
    color_positive = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines)
    color_negative = imgui_color(RGBA(0.4, 0.1, 0.15, 0.9))
    color_hovered = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    rounding = 0
    barsize = (graph_size.y - 2frame_padding.y) / len
    barsize_pad = barsize < 5 ? 0 : 3
    textsize = 80
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
            CImGui.Text(string(caption, "\n", "value: ", value))
            CImGui.EndTooltip()
            color = color_hovered
            color_caption = color_hovered
        else
            color = value > 0 ? color_positive : color_negative
            color_caption = color_positive
        end
        CImGui.SetCursorScreenPos(captionpos)
        CImGui.TextColored(color_caption, caption)
        CImGui.AddRectFilled(draw_list, p_min, p_max, color, rounding)
    end
    CImGui.SetCursorScreenPos(window_pos + ImVec2(graph_size.x + 4, 3))
    CImGui.Text(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_control_item(imctx::Ptr, item::LinePlot)
    values = item.values # :values
    label = get_prop(item, :label)
    scale = get_prop_scale(item) # :scale
    plot_color = get_prop(item, :color)
    line_color = plot_color === nothing ? CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines) : imgui_color(plot_color)
    line_thickness = 2
    graph_size = get_prop_frame_size(item, (width=CImGui.CalcItemWidth(), height=150)) # :frame
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    frame_rounding = Cfloat(1)
    frame_padding = (x=2, y=7)
    frame_bb = CImGui.ImVec4(window_pos, window_pos + ImVec2(graph_size.x, graph_size.y))
    _renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)

    min_y, max_y = scale
    len = length(values)
    barsize = (graph_size.x - 2frame_padding.x) / len
    barsize_pad = barsize < 5 ? 0 : 4
    locate = (y = (graph_size.y - 2frame_padding.y) / (max_y - min_y), )
    points = []
    for (idx, value) in enumerate(values)
        barheight = (value - min_y) * locate.y
        pos = ((idx - 1) * barsize + frame_padding.x, graph_size.y - frame_padding.y - barheight)
        p_min = imgui_offset_vec2(window_pos, pos)
        p_max = imgui_offset_vec2(window_pos, pos .+ (barsize .- barsize_pad, barheight))
        center = ImVec2(p_min.x + barsize/2, p_min.y)
        push!(points, center)
    end
    if length(points) >= 2
        for (a, b) in zip(points[1:end-1], points[2:end])
            CImGui.AddLine(draw_list, a, b, line_color, line_thickness)
        end
    end
    point_radius = 2
    num_segments = 5
    for (idx, center) in enumerate(points)
        if rect_contains_pos(center, point_radius + 3, mouse_pos)
            point_color = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
            CImGui.BeginTooltip()
            CImGui.Text(string("index: ", idx, "\n", "value: ", values[idx]))
            CImGui.EndTooltip()
        else
            point_color = CImGui.GetColorU32(CImGui.ImGuiCol_PlotHistogram)
        end
        CImGui.AddCircleFilled(draw_list, center, point_radius, point_color, num_segments)
    end
    CImGui.SetCursorScreenPos(window_pos + ImVec2(graph_size.x + 6, 3))
    CImGui.Text(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

function imgui_control_item(imctx::Ptr, item::MultiLinePlot)
    plot_items = item.items # :items
    label = get_prop(item, :label)
    scale = get_prop_scale(item) # :scale
    graph_size = get_prop_frame_size(item, (width=CImGui.CalcItemWidth(), height=150)) # :frame
    draw_list = CImGui.GetWindowDrawList()
    window_pos = CImGui.GetCursorScreenPos()
    mouse_pos = CImGui.GetIO().MousePos
    frame_rounding = Cfloat(1)
    frame_padding = (x=2, y=7)
    frame_bb = CImGui.ImVec4(window_pos, window_pos + ImVec2(graph_size.x, graph_size.y))
    _renderframe(draw_list, ImVec2(frame_bb, min), ImVec2(frame_bb, max), CImGui.GetColorU32(CImGui.ImGuiCol_FrameBg), true, frame_rounding)

    min_y, max_y = scale
    rounding = 0
    len = length(first(plot_items).values)
    barsize = (graph_size.x - 2frame_padding.x) / len
    barsize_pad = barsize < 5 ? 0 : 4
    locate = (y = (graph_size.y - 2frame_padding.y) / (max_y - min_y), )
    line_thickness = 2
    hovered_idx = nothing
    hovered_points = nothing
    hovered_color = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLinesHovered)
    label_color = CImGui.GetColorU32(CImGui.ImGuiCol_Text)
    point_radius = 2
    for (plot_idx, lineplot) in enumerate(plot_items)
        points = []
        line_color = imgui_color(lineplot.color)
        point_color = CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines)
        for (idx, value) in enumerate(lineplot.values)
            barheight = (value - min_y) * locate.y
            pos = ((idx - 1) * barsize + frame_padding.x, graph_size.y - frame_padding.y - barheight)
            p_min = imgui_offset_vec2(window_pos, pos)
            p_max = imgui_offset_vec2(window_pos, pos .+ (barsize .- barsize_pad, barheight))
            center = ImVec2(p_min.x + barsize/2, p_min.y)
            push!(points, center)
            if hovered_idx === nothing && rect_contains_pos(center, point_radius + 2, mouse_pos)
                line_color = hovered_color
                hovered_idx = plot_idx
                CImGui.BeginTooltip()
                CImGui.Text(string(lineplot.label, "\n", "index: ", idx, "\n", "value: ", value))
                CImGui.EndTooltip()
            end
        end
        a = imgui_offset_vec2(window_pos, (graph_size.x + 5, (plot_idx - 1) * 20 + 10))
        b = imgui_offset_vec2(a, (30, 0))
        if hovered_idx === nothing && rect_contains_pos(ImVec4(imgui_offset_vec2(a, (0, -5)), imgui_offset_vec2(b, (80, 10))), mouse_pos)
            hovered_idx = plot_idx
            line_color = hovered_color
        end
        if hovered_idx === plot_idx
            hovered_points = points
        end
        if hovered_points !== plot_idx && length(points) >= 2
            for (a, b) in zip(points[1:end-1], points[2:end])
                CImGui.AddLine(draw_list, a, b, line_color, line_thickness)
            end
        end
        num_segments = 5
        for (idx, center) in enumerate(points)
            CImGui.AddCircleFilled(draw_list, center, point_radius, hovered_idx == plot_idx ? line_color : point_color, num_segments)
        end
        CImGui.AddLine(draw_list, a, b, line_color, 5)
        CImGui.SetCursorScreenPos(imgui_offset_vec2(b, (5, -7)))
        CImGui.TextColored(label_color, lineplot.label)
    end
    if hovered_points !== nothing && length(hovered_points) >= 2
        for (a, b) in zip(hovered_points[1:end-1], hovered_points[2:end])
            CImGui.AddLine(draw_list, a, b, hovered_color, line_thickness)
        end
    end

    CImGui.SetCursorScreenPos(window_pos + ImVec2(graph_size.x + 6, graph_size.y - 20))
    CImGui.Text(label)
    margin = (x=0, y=5)
    CImGui.SetCursorScreenPos(window_pos + ImVec2(0, graph_size.y + margin.y))
end

# CImGui.PlotHistogram
function imgui_control_item(imctx::Ptr, item::Histogram)
    values = Cfloat.(item.values) # :values
    label = get_prop(item, :label)
    scale = get_prop_scale(item) # :scale
    graph_size = get_prop_frame_size(item, (width=0, height=0)) # :frame
    overlay_text = get_prop(item, :overlay_text)
    CImGui.PlotHistogram(label, values, length(values), Cint(0), overlay_text, scale.min, scale.max, graph_size)
end

# module Poptart.Desktop
