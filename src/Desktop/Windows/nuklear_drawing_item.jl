# module Poptart.Desktop.Windows 

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Line)
    point1, point2 = element.points
    color = nuklear_rgba(element.color)
    nk_stroke_line(canvas, point1..., point2..., element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Rect)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_stroke_rect(canvas, rect, element.rounding, element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Rect)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_fill_rect(canvas, rect, element.rounding, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::RectMultiColor)
    rect = nk_rect(element.rect...)
    colors = nuklear_rgba.((element.left, element.top, element.right, element.bottom))
    nk_fill_rect_multi_color(canvas, rect, colors...)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Circle)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_stroke_circle(canvas, rect, element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Circle)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_fill_circle(canvas, rect, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Triangle)
    point1, point2, point3 = element.points
    color = nuklear_rgba(element.color)
    nk_stroke_triangle(canvas, point1..., point2..., point3..., element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Triangle)
    point1, point2, point3 = element.points
    color = nuklear_rgba(element.color)
    nk_fill_triangle(canvas, point1..., point2..., point3..., color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Arc)
    angle = element.angle
    color = nuklear_rgba(element.color)
    nk_stroke_arc(canvas, element.center..., element.radius, angle.min, angle.max, element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Arc)
    angle = element.angle
    color = nuklear_rgba(element.color)
    nk_fill_arc(canvas, element.center..., element.radius, angle.min, angle.max, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Curve)
    color = nuklear_rgba(element.color)
    nk_stroke_curve(canvas, element.startPoint..., element.control1..., element.control2..., element.endPoint..., element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Polyline)
    points = Cfloat.(vcat(collect.(element.points)...))
    color = nuklear_rgba(element.color)
    nk_stroke_polyline(canvas, points, length(element.points), element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Polygon)
    points = Cfloat.(vcat(collect.(element.points)...))
    color = nuklear_rgba(element.color)
    nk_stroke_polygon(canvas, points, length(element.points), element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Polygon)
    points = Cfloat.(vcat(collect.(element.points)...))
    color = nuklear_rgba(element.color)
    nk_fill_polygon(canvas, points, length(element.points), color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{Drawings.stroke_and_fill}, element)
    nuklear_drawing_item(canvas, Drawings.Drawing{stroke}(element), element)
    nuklear_drawing_item(canvas, Drawings.Drawing{fill}(element), element)
end

function nuklear_drawing_item(nk_ctx::Ptr{LibNuklear.nk_context}, canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{Drawings.draw}, element::TextBox)
    font_handle = FontAtlas.get_font_handle(element.font)
    if C_NULL != font_handle
        str = element.text
        len = sizeof(element.text)
        rect = nk_rect(element.rect...)
        bg = nk_rgba(0, 0, 0, 0)
        fg = nuklear_rgba(element.color)
        nk_style_push_font(nk_ctx, font_handle)
        nk_draw_text(canvas, rect, str, len, font_handle, bg, fg)
        nk_style_pop_font(nk_ctx)
    end
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, ::Ptr{LibNuklear.nk_command_buffer}, drawing::Drawings.Drawing, ::Any)
    @info "not implemented" drawing
end

# module Poptart.Desktop.Windows 
