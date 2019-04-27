# module Poptart.Desktop.Windows 

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Line)
    point1, point2 = element.points
    color = nuklear_color(element.color)
    offset = vec(window_pos)
    nk_stroke_line(painter, (offset .+ point1)..., (offset .+ point2)..., element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Rect)
    rect = nuklear_rect(window_pos, element.rect)
    color = nuklear_color(element.color)
    nk_stroke_rect(painter, rect, element.rounding, element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{fill}, element::Rect)
    rect = nuklear_rect(window_pos, element.rect)
    color = nuklear_color(element.color)
    nk_fill_rect(painter, rect, element.rounding, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{fill}, element::RectMultiColor)
    rect = nuklear_rect(window_pos, element.rect)
    colors = nuklear_color.((element.left, element.top, element.right, element.bottom))
    nk_fill_rect_multi_color(painter, rect, colors...)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Circle)
    rect = nuklear_rect(window_pos, element.rect)
    color = nuklear_color(element.color)
    nk_stroke_circle(painter, rect, element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{fill}, element::Circle)
    rect = nuklear_rect(window_pos, element.rect)
    color = nuklear_color(element.color)
    nk_fill_circle(painter, rect, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Triangle)
    point1, point2, point3 = element.points
    color = nuklear_color(element.color)
    offset = vec(window_pos)
    nk_stroke_triangle(painter, (offset .+ point1)..., (offset .+ point2)..., (offset .+ point3)..., element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{fill}, element::Triangle)
    point1, point2, point3 = element.points
    color = nuklear_color(element.color)
    offset = vec(window_pos)
    nk_fill_triangle(painter, (offset .+ point1)..., (offset .+ point2)..., (offset .+ point3)..., color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Arc)
    angle = element.angle
    color = nuklear_color(element.color)
    offset = vec(window_pos)
    nk_stroke_arc(painter, (offset .+ element.center)..., element.radius, angle.min, angle.max, element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{fill}, element::Arc)
    angle = element.angle
    color = nuklear_color(element.color)
    offset = vec(window_pos)
    nk_fill_arc(painter, (offset .+ element.center)..., element.radius, angle.min, angle.max, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Curve)
    color = nuklear_color(element.color)
    offset = vec(window_pos)
    nk_stroke_curve(painter, (offset .+ element.startPoint)..., (offset .+ element.control1)..., (offset .+ element.control2)..., (offset .+ element.endPoint)..., element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Polyline)
    offset = vec(window_pos)
    points = Cfloat.(vcat(map(v -> v .+ offset, element.points)...))
    color = nuklear_color(element.color)
    nk_stroke_polyline(painter, points, length(element.points), element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{stroke}, element::Polygon)
    offset = vec(window_pos)
    points = Cfloat.(vcat(map(v -> v .+ offset, element.points)...))
    color = nuklear_color(element.color)
    nk_stroke_polygon(painter, points, length(element.points), element.thickness, color)
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{fill}, element::Polygon)
    offset = vec(window_pos)
    points = Cfloat.(vcat(map(v -> v .+ offset, element.points)...))
    color = nuklear_color(element.color)
    nk_fill_polygon(painter, points, length(element.points), color)
end

function nuklear_drawing_item(nk_ctx::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{Drawings.stroke_and_fill}, element)
    nuklear_drawing_item(nk_ctx, painter, window_pos, Drawings.Drawing{stroke}(element), element)
    nuklear_drawing_item(nk_ctx, painter, window_pos, Drawings.Drawing{fill}(element), element)
end

function nuklear_drawing_item(nk_ctx::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{Drawings.draw}, element::TextBox)
    font_handle = FontAtlas.get_font_handle(haskey(element.props, :font) ? element.font : FontAtlas.DEFAULT_FONT)
    if C_NULL != font_handle
        str = element.text
        len = sizeof(element.text)
        rect = nuklear_rect(window_pos, element.rect)
        bg = nk_rgba(0, 0, 0, 0)
        fg = nuklear_color(element.color)
        nk_style_push_font(nk_ctx, font_handle)
        nk_draw_text(painter, rect, str, len, font_handle, bg, fg)
        nk_style_pop_font(nk_ctx)
    end
end

function nuklear_drawing_item_imagebox(element::ImageBox, p::Union{Nothing,ProgressMeter.Progress})
    #= =# p !== nothing && ProgressMeter.next!(p)
    data = transpose(Controls.Images.load(element.path))
    (img_width, img_height) = Base.size(data)
    #= =# p !== nothing && ProgressMeter.next!(p)
    texture_index = nk_glfw3_create_texture(img_width, img_height, format=GL_RGBA, type=GL_FLOAT)
    #= =# p !== nothing && ProgressMeter.next!(p)
    chanview = Controls.Images.channelview(data)
    #= =# p !== nothing && ProgressMeter.next!(p)
    img = Array{Float32}(chanview)
    #= =# p !== nothing && ProgressMeter.next!(p)
    nk_glfw3_update_texture(texture_index, img, img_width, img_height, format=GL_RGBA, type=GL_FLOAT)
    #= =# p !== nothing && ProgressMeter.next!(p)
    return texture_index
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, painter::Ptr{LibNuklear.nk_command_buffer}, window_pos::nk_vec2, ::Drawings.Drawing{Drawings.draw}, element::ImageBox)
    if !haskey(element.props, :imageref)
        #= =# p = nothing
        if !isdefined(Controls, :Images)
            #= =# p = ProgressMeter.Progress(11, desc=string("Loading ", basename(element.path), " "), color=:normal)
            #= =# ProgressMeter.update!(p, 0)
            Base.eval(Controls, :(using Images))
            #= =# ProgressMeter.update!(p, 3)
        end
        texture_index = Base.invokelatest(nuklear_drawing_item_imagebox, element, p)
        element.props[:texture_index] = texture_index
        #= =# p !== nothing && ProgressMeter.next!(p)
        element.props[:imageref] = Ref(create_nk_image(texture_index))
        #= =# p !== nothing && ProgressMeter.finish!(p)
        #= =# p !== nothing && ProgressMeter.move_cursor_up_while_clearing_lines(p.output, p.numprintedvalues+1)
    end
    rect = nuklear_rect(window_pos, element.rect)
    nk_draw_image(painter, rect, element.props[:imageref], nk_rgba(255, 255, 255, 255))
end

function nuklear_drawing_item(::Ptr{LibNuklear.nk_context}, ::Ptr{LibNuklear.nk_command_buffer}, ::nk_vec2, drawing::Drawings.Drawing, ::Any)
    @info "not implemented" drawing
end

# module Poptart.Desktop.Windows 
