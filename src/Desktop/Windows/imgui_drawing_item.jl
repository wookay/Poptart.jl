# module Poptart.Desktop.Windows

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{stroke}, element::Line)
    point1, point2 = element.points
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    color = imgui_color(element.color)
    CImGui.AddLine(draw_list, a, b, color, element.thickness)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{stroke}, element::Rect)
    (a, b) = imgui_offset_rect(window_pos, element.rect)
    color = imgui_color(element.color)
    rounding_corners_flags = CImGui.ImDrawCornerFlags_All
    CImGui.AddRect(draw_list, a, b, color, element.rounding, rounding_corners_flags, element.thickness)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{fill}, element::Rect)
    (a, b) = imgui_offset_rect(window_pos, element.rect)
    color = imgui_color(element.color)
    rounding_corners_flags = CImGui.ImDrawCornerFlags_All
    CImGui.AddRectFilled(draw_list, a, b, color, element.rounding, rounding_corners_flags)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{fill}, element::RectMultiColor)
    (a, b) = imgui_offset_rect(window_pos, element.rect)
    col_upr_left  = imgui_color(element.color_upper_left)
    col_upr_right = imgui_color(element.color_upper_right)
    col_bot_left  = imgui_color(element.color_bottom_left)
    col_bot_right = imgui_color(element.color_bottom_right)
    CImGui.AddRectFilledMultiColor(draw_list, a, b, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{stroke}, element::Circle)
    centre = imgui_offset_vec2(window_pos, element.centre)
    radius = element.radius
    color = imgui_color(element.color)
    num_segments = haskey(element.props, :num_segments) ? element.num_segments : 32
    CImGui.AddCircle(draw_list, centre, radius, color, num_segments, element.thickness)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{fill}, element::Circle)
    centre = imgui_offset_vec2(window_pos, element.centre)
    radius = element.radius
    color = imgui_color(element.color)
    num_segments = haskey(element.props, :num_segments) ? element.num_segments : 32
    CImGui.AddCircleFilled(draw_list, centre, radius, color, num_segments)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{stroke}, element::Triangle)
    point1, point2, point3 = element.points
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    c = imgui_offset_vec2(window_pos, point3)
    color = imgui_color(element.color)
    CImGui.AddTriangle(draw_list, a, b, c, color, element.thickness)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{fill}, element::Triangle)
    point1, point2, point3 = element.points
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    c = imgui_offset_vec2(window_pos, point3)
    color = imgui_color(element.color)
    CImGui.AddTriangleFilled(draw_list, a, b, c, color)
end

function imgui_drawing_item(::Any, draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawings.Drawing{stroke}, element::Curve)
    pos0 = imgui_offset_vec2(window_pos, element.startPoint)
    cp0 = imgui_offset_vec2(window_pos, element.control1)
    cp1 = imgui_offset_vec2(window_pos, element.control2)
    pos1 = imgui_offset_vec2(window_pos, element.endPoint)
    color = imgui_color(element.color)
    num_segments = 0
    CImGui.AddBezierCurve(draw_list, pos0, cp0, cp1, pos1, color, element.thickness, num_segments)
end

# Arc

# Polyline

# Polygon

function imgui_drawing_item(::Any, ::Any, ::Any, drawing::Drawings.Drawing, ::Any)
    @onlyonce begin
        @info "not implemented" drawing
    end
end

# module Poptart.Desktop.Windows
