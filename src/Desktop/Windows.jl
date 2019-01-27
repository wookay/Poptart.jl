module Windows # Poptart.Desktop

using ..Desktop: UIApplication, UIWindow
using ..Controls

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend # nk_glfw3_create_texture
using ModernGL # glViewport glClear glClearColor GL_RGBA GL_FLOAT

struct Container
    items::Vector
end

struct Window <: UIWindow
    container::Container
    props::Dict{Symbol,Any}

    function Window(items = []; props...)
        container = Container(items)
        new(container, Dict(props...))
    end
end

function Base.setproperty!(window::W, prop::Symbol, val) where {W <: UIWindow}
    if prop in (:container, :props)
        setfield!(window, prop, val)
    elseif prop in properties(window)
        window.props[prop] = val
    else
        throw(KeyError(prop))
    end
end

function Base.getproperty(window::W, prop::Symbol) where {W <: UIWindow}
    if prop in (:container, :props)
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

# nuklear_widget
function nuklear_widget(nk_ctx, item::Button)
    nk_layout_row_static(nk_ctx, item.frame.height, item.frame.width, 1)
    nk_button_label(nk_ctx, item.title) == 1 && @async Mouse.click(item)
end

function nuklear_widget(nk_ctx, item::Label)
    nk_layout_row_dynamic(nk_ctx, 20, 1)
    nk_label(nk_ctx, item.text, NK_TEXT_LEFT)
end

function nuklear_widget(nk_ctx, item::SelectableLabel)
    nk_layout_row_dynamic(nk_ctx, 20, 1)
    nk_selectable_label(nk_ctx, item.text, NK_TEXT_LEFT, item.selected) == 1 && @async Mouse.click(item)
end

function nuklear_widget(nk_ctx, item::Slider)
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

function nuklear_widget(nk_ctx, item::Checkbox)
    nk_checkbox_label(nk_ctx, item.text, item.active) == 1 && @async Mouse.click(item)
end

function nuklear_widget(nk_ctx, item::Radio)
    for (name, value) in pairs(item.options)
        if nk_option_label(nk_ctx, String(name), item.value == value) == 1
            if item.value != value
                item.value = value
                @async Mouse.click(item)
            end
        end
    end
end

function nuklear_widget(nk_ctx, item::ProgressBar)
    nk_progress(nk_ctx, item.value, item.max, item.modifyable ? NK_MODIFIABLE : NK_FIXED) == 1 && @async Mouse.click(item)
end

function nuklear_imageview(item::ImageView)
    data = transpose(Controls.Images.load(item.path))
    (img_width, img_height) = Base.size(data)
    texture_index = nk_glfw3_create_texture(img_width, img_height, format=GL_RGBA, type=GL_FLOAT)
    chanview = Controls.Images.channelview(data)
    img = Array{Float32}(chanview)
    nk_glfw3_update_texture(texture_index, img, img_width, img_height, format=GL_RGBA, type=GL_FLOAT)
    return texture_index
end

function nuklear_widget(nk_ctx, item::ImageView)
    canvas = nk_window_get_canvas(nk_ctx)
    region = nk_window_get_content_region(nk_ctx)
    if !haskey(item.props, :imageref)
        texture_index = Base.invokelatest(nuklear_imageview, item)
        item.props[:imageref] = Ref(create_nk_image(texture_index))
    end
    nk_draw_image(canvas, region, item.props[:imageref], nk_rgba(255, 255, 255, 255))
end

function nuklear_widget(nk_ctx, item::Any)
    @info "not implemented" item
end

function setup_window(nk_ctx, window::W; frame, flags, title="") where {W <: UIWindow}
    if Bool(nk_begin(nk_ctx, title, nk_rect(values(frame)...), flags))
        nuklear_widget.(nk_ctx, window.container.items)
    end
    nk_end(nk_ctx)
end


# window states
function iscollapsed(app::A, window::W) where {A <: UIApplication, W <: UIWindow}
    nk_window_is_collapsed(app.nk_ctx, window.title) != 0
end

end # Poptart.Desktop.Windows
