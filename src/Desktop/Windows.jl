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
    Window(items::Vector{<:UIControl} = UIControl[]; title::String, frame::NamedTuple{(:x,:y,:width,:height)}, name::Union{Nothing,String}=nothing, flags=NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | NK_WINDOW_SCALABLE | NK_WINDOW_MINIMIZABLE | NK_WINDOW_TITLE)
"""
struct Window <: UIWindow
    container::Controls.Container
    props::Dict{Symbol,Any}

    function Window(items::Vector{<:UIControl} = UIControl[]; title::String, frame::NamedTuple{(:x,:y,:width,:height)}, name::Union{Nothing,String}=nothing, flags=NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | NK_WINDOW_SCALABLE | NK_WINDOW_MINIMIZABLE | NK_WINDOW_TITLE)
        container = Controls.Container(items)
        props = Dict{Symbol,Any}(:title => title, :frame => frame, :name => name, :flags => flags)
        window = new(container, props)
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
    (:title, :frame, :name, :flags, )
end

# nuklear convert
function nuklear_rect(frame::NamedTuple{(:x,:y,:width,:height)})
    nk_rect(values(frame)...)
end

function nuklear_rgba(c::RGBA)
    nk_rgba(round.(Int, 0xff .* (c.r,c.g,c.b,c.alpha))...)
end

include("Windows/nuklear_item.jl")
include("Windows/nuklear_drawing_item.jl")

function show(nk_ctx::Ptr{LibNuklear.nk_context}, controls::UIControl...)
    for item in controls
        nuklear_item(nk_ctx, item) do nk_ctx, item
        end
    end
end

function setup_window(nk_ctx::Ptr{LibNuklear.nk_context}, window::W) where {W <: UIWindow}
    rect = nuklear_rect(window.frame)
    if window.name === nothing
        can_be_filled_up_with_widgets = nk_begin(nk_ctx, window.title, rect, window.flags)
    else
        can_be_filled_up_with_widgets = nk_begin_titled(nk_ctx, window.name, window.title, rect, window.flags)
    end
    if Bool(can_be_filled_up_with_widgets)
        for item in window.container.items
            nuklear_item(nk_ctx, item) do nk_ctx, item
                if haskey(item.observers, :ongoing)
                    for ongoing in item.observers[:ongoing]
                        Bool(nk_widget_is_hovered(nk_ctx)) && ongoing((action=Mouse.hover, context=nk_ctx))
                    end
                end
            end
        end
    end
    nk_end(nk_ctx)
end


# window states

get_window_name(window::W) where {W <: UIWindow} = window.name === nothing ? window.title : window.name

function is_collapsed(app::A, window::W) where {A <: UIApplication, W <: UIWindow}
    nk_window_is_collapsed(app.nk_ctx, get_window_name(window)) != 0
end

function set_bounds(app::A, window::W, frame::NamedTuple{(:x,:y,:width,:height)}) where {A <: UIApplication, W <: UIWindow}
    nk_window_set_bounds(app.nk_ctx, get_window_name(window), nuklear_rect(frame))
end

"""
    put!(window::W, controls::UIControl...) where {W <: UIWindow}
"""
function Base.put!(window::W, controls::UIControl...) where {W <: UIWindow}
    push!(window.container.items, controls...)
end

end # Poptart.Desktop.Windows
