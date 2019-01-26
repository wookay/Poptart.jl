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

# nuklear_item
function nuklear_item(ctx, item::Button)
    nk_layout_row_static(ctx, item.frame.height, item.frame.width, 1)
    nk_button_label(ctx, item.title) == 1 && @async Mouse.click(item)
end

function nuklear_item(ctx, item::Label)
    nk_layout_row_dynamic(ctx, 20, 1)
    nk_label(ctx, item.text, NK_TEXT_LEFT)
end

function nuklear_item(ctx, item::Slider)
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
    f(ctx, min, val, max, step) == 1 && @async Mouse.click(item)
end

function nuklear_item(ctx, item::CheckBox)
    nk_checkbox_label(ctx, item.text, item.active) == 1 && @async Mouse.click(item)
end

function nuklear_item(ctx, item::ProgressBar)
    nk_progress(ctx, item.value, item.max, item.modifyable ? NK_MODIFIABLE : NK_FIXED) == 1 && @async Mouse.click(item)
end

function nuklear_item(ctx, item::Any)
    @info "not implemented" item
end

function setup_window(ctx, window::Window; frame, flags, title="")
    if Bool(nk_begin(ctx, title, nk_rect(values(frame)...), flags))
        nuklear_item.(ctx, window.container.items)
    end
    nk_end(ctx)
end

end # Poptart.Desktop.Windows
