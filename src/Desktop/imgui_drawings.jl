# module Poptart.Desktop

function get_prop(element::DrawingElement, name::Symbol, default::Any)
    get(element.props, name, default)
end

function get_prop_color(element::DrawingElement, default::ImU32=CImGui.GetColorU32(CImGui.ImGuiCol_PlotLines))::ImU32
    haskey(element.props, :color) ? imgui_color(element.color) : default
end


function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Line)
    point1, point2 = element.points # :points
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    color = imgui_color(element.color)
    CImGui.AddLine(draw_list, a, b, color, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Rect)
    (a, b) = imgui_offset_rect(window_pos, element.rect) # :rect
    rounding = get_prop(element, :rounding, 0)
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    rounding_corners_flags = CImGui.ImDrawCornerFlags_All
    CImGui.AddRect(draw_list, a, b, color, rounding, rounding_corners_flags, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Rect)
    (a, b) = imgui_offset_rect(window_pos, element.rect) # :rect
    rounding = get_prop(element, :rounding, 0)
    color = get_prop_color(element) # :color
    rounding_corners_flags = CImGui.ImDrawCornerFlags_All
    CImGui.AddRectFilled(draw_list, a, b, color, rounding, rounding_corners_flags)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::RectMultiColor)
    (a, b) = imgui_offset_rect(window_pos, element.rect) # :rect
    col_upr_left  = imgui_color(element.color_upper_left) # :color_upper_left
    col_upr_right = imgui_color(element.color_upper_right) # :color_upper_right
    col_bot_left  = imgui_color(element.color_bottom_left) # :color_bottom_left
    col_bot_right = imgui_color(element.color_bottom_right) # :color_bottom_right
    CImGui.AddRectFilledMultiColor(draw_list, a, b, col_upr_left, col_upr_right, col_bot_right, col_bot_left)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Circle)
    center = imgui_offset_vec2(window_pos, element.center) # :center
    radius = element.radius # :radius
    num_segments = element.num_segments # :num_segments
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    CImGui.AddCircle(draw_list, center, radius, color, num_segments, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Circle)
    center = imgui_offset_vec2(window_pos, element.center)
    radius = element.radius # :radius
    color = imgui_color(element.color) # :color
    num_segments = element.num_segments # :num_segments
    CImGui.AddCircleFilled(draw_list, center, radius, color, num_segments)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Quad)
    point1, point2, point3, point4 = element.points # :points
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    c = imgui_offset_vec2(window_pos, point3)
    d = imgui_offset_vec2(window_pos, point4)
    CImGui.AddQuad(draw_list, a, b, c, d, color, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Quad)
    point1, point2, point3, point4 = element.points # :points
    color = get_prop_color(element) # :color
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    c = imgui_offset_vec2(window_pos, point3)
    d = imgui_offset_vec2(window_pos, point4)
    CImGui.AddQuadFilled(draw_list, a, b, c, d, color)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Triangle)
    point1, point2, point3 = element.points # :points
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    c = imgui_offset_vec2(window_pos, point3)
    CImGui.AddTriangle(draw_list, a, b, c, color, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Triangle)
    point1, point2, point3 = element.points # :points
    color = get_prop_color(element) # :color
    a = imgui_offset_vec2(window_pos, point1)
    b = imgui_offset_vec2(window_pos, point2)
    c = imgui_offset_vec2(window_pos, point3)
    CImGui.AddTriangleFilled(draw_list, a, b, c, color)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Arc)
    center = imgui_offset_vec2(window_pos, element.center) # :center
    a_min, a_max = element.angle # :angle
    radius = element.radius # :radius
    num_segments = element.num_segments # :num_segments
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    CImGui.PathArcTo(draw_list, center, radius, a_min, a_max, num_segments)
    closed = false
    CImGui.PathStroke(draw_list, color, closed, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Arc)
    center = imgui_offset_vec2(window_pos, element.center) # :center
    a_min, a_max = element.angle # :angle
    radius = element.radius # :radius
    num_segments = element.num_segments # :num_segments
    color = get_prop_color(element) # :color
    CImGui.PathArcTo(draw_list, center, radius, a_min, a_max, num_segments)
    CImGui.PathFillConvex(draw_list, color)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Pie)
    center = imgui_offset_vec2(window_pos, element.center) # :center
    a_min, a_max = element.angle # :angle
    radius = element.radius # :radius
    num_segments = element.num_segments # :num_segments
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    CImGui.PathLineTo(draw_list, center)
    CImGui.PathArcTo(draw_list, center, radius, a_min, a_max, num_segments)
    closed = true
    CImGui.PathStroke(draw_list, color, closed, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Pie)
    center = imgui_offset_vec2(window_pos, element.center) # :center
    a_min, a_max = element.angle # :angle
    radius = element.radius # :radius
    num_segments = element.num_segments # :num_segments
    color = get_prop_color(element) # :color
    CImGui.PathLineTo(draw_list, center)
    CImGui.PathArcTo(draw_list, center, radius, a_min, a_max, num_segments)
    CImGui.PathFillConvex(draw_list, color)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Curve)
    pos0 = imgui_offset_vec2(window_pos, element.startPoint) # :startPoint
    cp0 = imgui_offset_vec2(window_pos, element.control1) # :control1
    cp1 = imgui_offset_vec2(window_pos, element.control2) # :control2
    pos1 = imgui_offset_vec2(window_pos, element.endPoint) # :endPoint
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    num_segments = 0
    CImGui.AddBezierCurve(draw_list, pos0, cp0, cp1, pos1, color, thickness, num_segments)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Polyline)
    points = map(point -> imgui_offset_vec2(window_pos, point), element.points) # :points
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    num_points = length(element.points)
    closed = false
    CImGui.AddPolyline(draw_list, points, num_points, color, closed, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{stroke}, element::Polygon)
    points = map(point -> imgui_offset_vec2(window_pos, point), element.points) # :points
    thickness = element.thickness # :thickness
    color = get_prop_color(element) # :color
    num_points = length(element.points)
    closed = true
    CImGui.AddPolyline(draw_list, points, num_points, color, closed, thickness)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{fill}, element::Polygon)
    points = map(point -> imgui_offset_vec2(window_pos, point), element.points) # :points
    color = get_prop_color(element) # :color
    num_points = length(element.points)
    CImGui.AddConvexPolyFilled(draw_list, points, num_points, color)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{Drawings.draw}, element::TextBox)
    text = element.text # :text
    pos = imgui_offset_vec2(window_pos, element.rect[1:2]) # :rect
    font_size = get_prop(element, :font_size, 20)
    color = get_prop_color(element, CImGui.GetColorU32(CImGui.ImGuiCol_Text)) # :color
    CImGui.AddText(draw_list, Ptr{CImGui.ImFont}(C_NULL), font_size, pos, color, text)
end

function imgui_drawing_item(draw_list::Ptr{ImDrawList}, window_pos::ImVec2, ::Drawing{Drawings.draw}, element::ImageBox)
    image = element.image
    image === nothing && return
    (w, h) = size(image)
    element_rect = get_prop(element, :rect, nothing)
    if element_rect === nothing
        rect = (0, 0, w, h)
    else
        rect = element_rect
    end
    if haskey(element.props, :tex_id)
        tex_id = element.tex_id
        if hash(element.image) == element.props[:hash]
        else
            if element.props[:texture_size] == (w, h)
            else
                ImGui_ImplOpenGL3_DestroyImageTexture(tex_id)
                tex_id = ImGui_ImplOpenGL3_CreateImageTexture(w, h)
                element.tex_id = tex_id
                element.props[:texture_size] = (w, h)
            end
            glubytes = imgui_glubytes(image)
            ImGui_ImplOpenGL3_UpdateImageTexture(tex_id, glubytes, w, h)
            element.props[:hash] = hash(image)
        end
    else
        tex_id = ImGui_ImplOpenGL3_CreateImageTexture(w, h)
        element.tex_id = tex_id
        element.props[:texture_size] = (w, h)

        glubytes = imgui_glubytes(image)
        ImGui_ImplOpenGL3_UpdateImageTexture(tex_id, glubytes, w, h)
        element.props[:hash] = hash(image)
    end
    (a, b) = imgui_offset_rect(window_pos, rect)
    CImGui.AddImage(draw_list, Ptr{Cvoid}(tex_id), a, b)
end

using Jive # @onlyonce
function imgui_drawing_item(::Ptr{ImDrawList}, ::ImVec2, drawing::Any, element::Any)
    @onlyonce begin
        @info "not implemented" drawing element
    end
end

# see also Controls/canvas.jl
function remove_imgui_drawing_item(element::ImageBox)
    if haskey(element.props, :tex_id)
        tex_id = element.tex_id
        ImGui_ImplOpenGL3_DestroyImageTexture(tex_id)
        delete!(element.props, :tex_id)
    end
end

function remove_imgui_drawing_item(::Any)
    nothing
end

# module Poptart.Desktop
