module Windows # Poptart.Desktop

using ..Desktop
using ..Controls

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend
using ModernGL # glViewport glClear glClearColor

abstract type UIWindow end

struct Container
    items
end

struct Window <: UIWindow
    container
    props

    function Window(items = []; props...)
        container = Container(items)
        new(container, props)
    end
end

function Base.getproperty(window::Window, prop::Symbol)
    if prop in (:container, :props)
        getfield(window, prop)
    elseif prop in properties(window)
        window.props[prop]
    end
end

function properties(::Window)
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

function nuklear_widget(nk_ctx, item::CheckBox)
    nk_checkbox_label(nk_ctx, item.text, item.active) == 1 && @async Mouse.click(item)
end

function nuklear_widget(nk_ctx, item::ProgressBar)
    nk_progress(nk_ctx, item.value, item.max, item.modifyable ? NK_MODIFIABLE : NK_FIXED) == 1 && @async Mouse.click(item)
end

function nuklear_widget(nk_ctx, item::OptionLabel)
    for (name, value) in pairs(item.options)
        if nk_option_label(nk_ctx, String(name), item.value == value) == 1
            if item.value != value
                item.value = value
                @async Mouse.click(item)
            end
        end
    end
end

function nuklear_widget(nk_ctx, item::Any)
    @info "not implemented" item
end

function setup_window(nk_ctx, window::Window; frame, flags, title="")
    if Bool(nk_begin(nk_ctx, title, nk_rect(values(frame)...), flags))
        nuklear_widget.(nk_ctx, window.container.items)
    end
    nk_end(nk_ctx)
end

end # Poptart.Desktop.Windows
