module Windows # Poptart.Desktop

using ..Desktop: UIApplication, UIWindow
using ...Controls
using ...Drawings # Line Rect Circle Arc Curve Polyline Polygon stroke fill
import ...Props: properties

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend # nk_glfw3_create_texture
using ModernGL # glViewport glClear glClearColor GL_RGBA GL_FLOAT
using Colors # RGBA
using ProgressMeter

"""
    Window(items = []; props...)
"""
struct Window <: UIWindow
    container::Controls.Container
    props::Dict{Symbol,Any}

    function Window(items = []; props...)
        container = Controls.Container(items)
        new(container, Dict(props...))
    end
end

function Base.setproperty!(window::W, prop::Symbol, val) where {W <: UIWindow}
    if prop in fieldnames(W)
        setfield!(window, prop, val)
    elseif prop in properties(window)
        window.props[prop] = val
    else
        throw(KeyError(prop))
    end
end

function Base.getproperty(window::W, prop::Symbol) where {W <: UIWindow}
    if prop in fieldnames(W)
        getfield(window, prop)
    elseif prop in properties(window)
        window.props[prop]
    else
        throw(KeyError(prop))
    end
end

function properties(::W) where {W <: UIWindow}
    (:title, :frame)
end

# nuklear_item
function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::Button) where {W <: UIWindow}
    nk_layout_row_static(nk_ctx, item.frame.height, item.frame.width, 1)
    nk_button_label(nk_ctx, item.title) == 1 && @async Mouse.click(item)
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::Label) where {W <: UIWindow}
    nk_layout_row_dynamic(nk_ctx, 20, 1)
    nk_label(nk_ctx, item.text, NK_TEXT_LEFT)
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::SelectableLabel) where {W <: UIWindow}
    nk_layout_row_dynamic(nk_ctx, 20, 1)
    nk_selectable_label(nk_ctx, item.text, NK_TEXT_LEFT, item.selected) == 1 && @async Mouse.click(item)
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::Slider) where {W <: UIWindow}
    if item.range isa StepRangeLen{Float64}
        f = nk_slider_float
        step = Float64(item.range.step)
    elseif item.range isa StepRange{Int}
        f = nk_slider_int
        step = item.step
    elseif item.range isa UnitRange{Int}
        f = nk_slider_int
        step = 1
    end
    min = minimum(item.range)
    max = maximum(item.range)
    val = item.value
    f(nk_ctx, min, val, max, step) == 1 && @async Mouse.click(item)
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::Checkbox) where {W <: UIWindow}
    nk_checkbox_label(nk_ctx, item.text, item.active) == 1 && @async Mouse.click(item)
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::Radio) where {W <: UIWindow}
    for (name, value) in pairs(item.options)
        if nk_option_label(nk_ctx, String(name), item.value == value) == 1
            if item.value != value
                item.value = value
                @async Mouse.click(item)
            end
        end
    end
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::ProgressBar) where {W <: UIWindow}
    nk_progress(nk_ctx, item.value, item.max, item.modifyable ? NK_MODIFIABLE : NK_FIXED) == 1 && @async Mouse.click(item)
end

function nuklear_item_imageview(item::ImageView, p::Union{Nothing,ProgressMeter.Progress})
    #= =# p !== nothing && ProgressMeter.next!(p)
    data = transpose(Controls.Images.load(item.path))
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

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::ImageView) where {W <: UIWindow}
    canvas = nk_window_get_canvas(nk_ctx)
    region = nk_window_get_content_region(nk_ctx)
    if !haskey(item.props, :imageref)
        #= =# p = nothing
        if !isdefined(Controls, :Images)
            #= =# p = ProgressMeter.Progress(11, desc=string("Loading ", basename(item.path), " "), color=:normal)
            #= =# ProgressMeter.update!(p, 0)
            Base.eval(Controls, :(using Images))
            #= =# ProgressMeter.update!(p, 3)
        end
        texture_index = Base.invokelatest(nuklear_item_imageview, item, p)
        #= =# p !== nothing && ProgressMeter.next!(p)
        item.props[:imageref] = Ref(create_nk_image(texture_index))
        #= =# p !== nothing && ProgressMeter.finish!(p)
        #= =# p !== nothing && ProgressMeter.move_cursor_up_while_clearing_lines(p.output, p.numprintedvalues+1)
    end
    nk_draw_image(canvas, region, item.props[:imageref], nk_rgba(255, 255, 255, 255))
end

function nuklear_rgba(c::RGBA)
    nk_rgba(round.(Int, 0xff .* (c.r,c.g,c.b,c.alpha))...)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Line)
    point1, point2 = element.points
    color = nuklear_rgba(element.color)
    nk_stroke_line(canvas, point1..., point2..., element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Rect)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_stroke_rect(canvas, rect, element.rounding, element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Rect)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_fill_rect(canvas, rect, element.rounding, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Circle)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_stroke_circle(canvas, rect, element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Circle)
    rect = nk_rect(element.rect...)
    color = nuklear_rgba(element.color)
    nk_fill_circle(canvas, rect, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Triangle)
    point1, point2, point3 = element.points
    color = nuklear_rgba(element.color)
    nk_stroke_triangle(canvas, point1..., point2..., point3..., element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Triangle)
    point1, point2, point3 = element.points
    color = nuklear_rgba(element.color)
    nk_fill_triangle(canvas, point1..., point2..., point3..., color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Arc)
    angle = element.angle
    color = nuklear_rgba(element.color)
    nk_stroke_arc(canvas, element.center..., element.radius, angle.min, angle.max, element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Arc)
    angle = element.angle
    color = nuklear_rgba(element.color)
    nk_fill_arc(canvas, element.center..., element.radius, angle.min, angle.max, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Curve)
    color = nuklear_rgba(element.color)
    nk_stroke_curve(canvas, element.startPoint..., element.control1..., element.control2..., element.endPoint..., element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Polyline)
    points = Cfloat.(vcat(collect.(element.points)...))
    color = nuklear_rgba(element.color)
    nk_stroke_polyline(canvas, points, length(element.points), element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{stroke}, element::Polygon)
    points = Cfloat.(vcat(collect.(element.points)...))
    color = nuklear_rgba(element.color)
    nk_stroke_polygon(canvas, points, length(element.points), element.thickness, color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, ::Drawings.Drawing{fill}, element::Polygon)
    points = Cfloat.(vcat(collect.(element.points)...))
    color = nuklear_rgba(element.color)
    nk_fill_polygon(canvas, points, length(element.points), color)
end

function nuklear_drawing_item(canvas::Ptr{LibNuklear.nk_command_buffer}, drawing::Drawings.Drawing, ::Any)
    @info "not implemented" drawing
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, window::W, item::Canvas) where {W <: UIWindow}
    canvas = nk_window_get_canvas(nk_ctx)
    #=
    https://github.com/vurtun/nuklear/blob/master/example/canvas.c#L358

    /* save style properties which will be overwritten */
    canvas->panel_padding = ctx->style.window.padding;
    canvas->item_spacing = ctx->style.window.spacing;
    canvas->window_background = ctx->style.window.fixed_background;

    /* use the complete window space and set background */
    ctx->style.window.spacing = nk_vec2(0,0);
    ctx->style.window.padding = nk_vec2(0,0);
    ctx->style.window.fixed_background = nk_style_item_color(background_color);
    =#
    for drawing in item.container.items
        nuklear_drawing_item(canvas, drawing, drawing.element)
    end
    #=
    ctx->style.window.spacing = canvas->panel_padding;
    ctx->style.window.padding = canvas->item_spacing;
    ctx->style.window.fixed_background = canvas->window_background;
    =#
end

function nuklear_item(nk_ctx::Ptr{LibNuklear.nk_context}, ::W, item::Any) where {W <: UIWindow}
    @info "not implemented" item
end

function setup_window(nk_ctx::Ptr{LibNuklear.nk_context}, window::W; frame::NT, flags, title="") where {W <: UIWindow, NT <: NamedTuple{(:x,:y,:width,:height)}}
    if Bool(nk_begin(nk_ctx, title, nk_rect(values(frame)...), flags))
        for item in window.container.items
            nuklear_item(nk_ctx, window, item)
        end
    end
    nk_end(nk_ctx)
end


# window states
function iscollapsed(app::A, window::W) where {A <: UIApplication, W <: UIWindow}
    nk_window_is_collapsed(app.nk_ctx, window.title) != 0
end

function setbounds(app::A, window::W, frame::T) where {A <: UIApplication, W <: UIWindow, T <: NamedTuple{(:x, :y, :width, :height)}}
    nk_window_set_bounds(app.nk_ctx, window.title, nk_rect(values(frame)...))
end


"""
    put!(window::W, controls::UIControl...) where {W <: UIWindow}
"""
function Base.put!(window::W, controls::UIControl...) where {W <: UIWindow}
    push!(window.container.items, controls...)
end

end # Poptart.Desktop.Windows
