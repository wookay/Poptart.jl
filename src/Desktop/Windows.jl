module Windows # Poptart.Desktop

export put!, remove!

import ...Interfaces: properties, put!, remove!
using ..Desktop: UIApplication, UIWindow
using ...Controls
using ...Drawings # Line Rect Circle Arc Curve Polyline Polygon stroke fill
using CImGui: CImGui
using .CImGui: ImVec2, ImVec4, ImU32, ImDrawList
using Colors: RGBA

include("Windows/imgui_convert.jl")
include("Windows/imgui_item.jl")
include("Windows/imgui_drawing_item.jl")

"""
    Window(; items::Vector{<:UIControl} = UIControl[], title::String="Title", frame::NamedTuple{(:x,:y,:width,:height)}, name::Union{Nothing,String}=nothing, flags=CImGui.ImGuiWindowFlags(0))
"""
struct Window <: UIWindow
    items::Vector{<:UIControl}
    props::Dict{Symbol,Any}

    function Window(; items::Vector{<:UIControl} = UIControl[], title::String="Title", frame::NamedTuple{(:x,:y,:width,:height)}, name::Union{Nothing,String}=nothing, flags=CImGui.ImGuiWindowFlags(0))
        props = Dict{Symbol,Any}(:title => title, :frame => frame, :name => nothing, :flags => flags)
        window = new(items, props)
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

function setup_window(imctx::Ptr, window::W, heartbeat) where {W <: UIWindow}
    (width, height) = (window.frame.width, window.frame.height)
    CImGui.SetNextWindowSize((width, height), CImGui.ImGuiCond_FirstUseEver)
    if window.name === nothing
        name = window.title
    else
        name = window.name
    end
    p_open = Ref(true)
    CImGui.Begin(name, p_open, window.flags) || (CImGui.End(); return)
    for item in window.items
        imgui_item(imctx, item) do imctx, item
        end
    end
    CImGui.End()
    heartbeat() do
        nothing
    end
end

"""
    Windows.put!(window::W, controls::UIControl...) where {W <: UIWindow}
"""
function put!(window::W, controls::UIControl...) where {W <: UIWindow}
    push!(window.items, controls...)
    nothing
end

"""
    Windows.remove!(window::W, controls::UIControl...) where {W <: UIWindow}
"""
function remove!(window::W, controls::UIControl...) where {W <: UIWindow}
    indices = filter(x -> x !== nothing, indexin(controls, window.items))
    deleteat!(window.items, indices)
    nothing
end

"""
    empty!(window::W) where {W <: UIWindow}
"""
function Base.empty!(window::W) where {W <: UIWindow}
    empty!(window.items)
end

end # Poptart.Desktop.Windows
