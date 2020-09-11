# module Poptart.Desktop

"""
    Window(; title::String="Title",
             frame::Union{NamedTuple{(:width,:height)}, NamedTuple{(:x,:y,:width,:height)}} = (width=400, height=300),
             items::Union{Vector{Any},Vector{<:UIControl}} = UIControl[],
             name::Union{Nothing,String}=nothing,
             show_window_closing_widget::Bool=true,
             flags=CImGui.ImGuiWindowFlags(0))
"""
mutable struct Window <: UIWindow
    items::Vector{UIControl}
    props::Dict{Symbol,Any}

    function Window(; items::Union{Vector{Any},Vector{<:UIControl}} = UIControl[],
                      title::String="Title",
                      frame::Union{NamedTuple{(:width,:height)}, NamedTuple{(:x,:y,:width,:height)}} = (width=400, height=300),
                      name::Union{Nothing,String}=nothing,
                      show_window_closing_widget::Bool=true,
                      flags=CImGui.ImGuiWindowFlags(0))
        props = Dict{Symbol,Any}(:title => title, :frame => merge((x=0, y=0), frame), :name => nothing, :show_window_closing_widget => show_window_closing_widget, :flags => flags)
        new(Vector{UIControl}(items), props)
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
    (:title, :frame, :name, :show_window_closing_widget, :flags, :isopen)
end

"""
    close(window::Window)

Close the window as if closing widget is clicked.

Note: window object is not destroyed.
"""
function Base.close(window::Window)
    window.props[:isopen] = Ref(false)
    return
end

"""
    open(window::Window)

Open the window if it is closed.
"""
function Base.open(window::Window)
    isopen(window) && return
    open_window(window)
end

function open_window(window::Window)
    if !window.props[:show_window_closing_widget]
        window.props[:isopen] = C_NULL
    else
        window.props[:isopen] = Ref(true)
    end
    return
end

function Base.isopen(window::Window)
    isopen_prop = window.props[:isopen]
    window_isopen(isopen_prop)
end

window_isopen(::Ptr{Nothing}) = true
window_isopen(x::Ref{Bool}) = x[]

function setup_window(ctx, window::Window)
    if !haskey(window.props, :isopen)
        open_window(window)
    elseif !isopen(window)
        return
    end

    (x, y) = (window.frame.x, window.frame.y)
    (width, height) = (window.frame.width, window.frame.height)
    CImGui.SetNextWindowPos((x, y), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((width, height), CImGui.ImGuiCond_FirstUseEver)
    name = something(window.props[:name], window.props[:title])
    CImGui.Begin(name, window.props[:isopen], window.props[:flags]) || (CImGui.End(); return)
    for item in window.items
        imgui_control_item(ctx, item)
    end
    CImGui.End()
end

# module Poptart.Desktop
