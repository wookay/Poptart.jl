module Windows # Poptart.Desktop

export put!, remove!

import ...Interfaces: properties, put!, remove!
using ..Desktop: UIApplication, UIWindow
using ...Controls
import .Controls: remove_imgui_drawing_item
using .Controls: LayoutElement
using ...Drawings # Line Rect Quad Triangle Circle Arc Curve Polyline Polygon TextBox ImageBox stroke fill
using .Drawings: DrawingElement
using CImGui: CImGui
using .CImGui: ImVec2, ImVec4, ImU32, ImDrawList
using Colors: RGBA, RGB
using ColorTypes
using FixedPointNumbers
using CImGui.OpenGLBackend: GLubyte, ImGui_ImplOpenGL3_CreateImageTexture, ImGui_ImplOpenGL3_UpdateImageTexture, ImGui_ImplOpenGL3_DestroyImageTexture


include("Windows/imgui_convert.jl")
include("Windows/imgui_controls.jl")
include("Windows/imgui_drawings.jl")

"""
    Window(; items::Union{Vector{Any},Vector{<:UIControl}} = UIControl[], title::String="Title", frame::Union{NamedTuple{(:width,:height)}, NamedTuple{(:x,:y,:width,:height)}} = (width=400, height=300), name::Union{Nothing,String}=nothing, flags=CImGui.ImGuiWindowFlags(0), pre_block=nothing, post_block=nothing)
"""
struct Window <: UIWindow
    items::Vector{UIControl}
    props::Dict{Symbol,Any}

    function Window(; items::Union{Vector{Any},Vector{<:UIControl}} = UIControl[], title::String="Title", frame::Union{NamedTuple{(:width,:height)}, NamedTuple{(:x,:y,:width,:height)}} = (width=400, height=300), name::Union{Nothing,String}=nothing, flags=CImGui.ImGuiWindowFlags(0), pre_block=nothing, post_block=nothing)
        props = Dict{Symbol,Any}(:title => title, :frame => merge((x=0, y=0), frame), :name => nothing, :flags => flags, :pre_block => pre_block, :post_block => post_block)
        window = new(Vector{UIControl}(items), props)
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
    (:title, :frame, :name, :flags, :pre_block, :post_block, )
end

function setup_window(imctx::Ptr, window::W, heartbeat, under_revise) where {W <: UIWindow}
    (x, y) = (window.frame.x, window.frame.y)
    (width, height) = (window.frame.width, window.frame.height)
    CImGui.SetNextWindowPos((x, y), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((width, height), CImGui.ImGuiCond_FirstUseEver)
    if window.name === nothing
        name = window.title
    else
        name = window.name
    end
    p_open = Ref(true)
    CImGui.Begin(name, p_open, window.flags) || (CImGui.End(); return)
    window.pre_block !== nothing && Base.invokelatest(window.pre_block)
    for item in window.items
        haskey(item.props, :pre_block) && item.pre_block !== nothing && Base.invokelatest(item.pre_block)
        if under_revise
            Base.invokelatest(imgui_control_item, imctx, item)
        else
            imgui_control_item(imctx, item)
        end
        haskey(item.props, :post_block) && item.post_block !== nothing && Base.invokelatest(item.post_block)
    end
    window.post_block !== nothing && Base.invokelatest(window.post_block)
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
    remove_imgui_control_item.(controls)
    nothing
end

"""
    empty!(window::W) where {W <: UIWindow}
"""
function Base.empty!(window::W) where {W <: UIWindow}
    remove_imgui_control_item.(window.items)
    empty!(window.items)
end

function Window(f::Function; kwargs...)
    Window(; post_block=f, kwargs...)
end

end # Poptart.Desktop.Windows
