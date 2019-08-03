# module Poptart.Controls

"""
    Canvas(; items::Vector{Union{Drawing, TextBox, ImageBox}} = Union{Drawing, TextBox, ImageBox}[])
"""
Canvas

@UI Canvas quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    items::Vector{Drawing}

    function Canvas(; items::Union{Vector{Any},Vector{Union{Drawing, TextBox, ImageBox}}} = Union{Drawing, TextBox, ImageBox}[], kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, Vector{Union{Drawing, TextBox, ImageBox}}(items))
    end
end

function properties(control::Canvas)
    (properties(super(control))..., )
end

"""
    Controls.put!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
"""
function put!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
    drawing_elements = convert.(Drawing, elements)
    push!(canvas.items, drawing_elements...)
    nothing
end

"""
    Controls.remove!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
"""
function remove!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
    drawing_elements = convert.(Drawing, elements)
    indices = filter(x -> x !== nothing, indexin(drawing_elements, canvas.items))
    deleteat!(canvas.items, indices)
    remove_imgui_drawing_item.(elements)
    nothing
end

"""
    empty!(canvas::Canvas)
"""
function Base.empty!(canvas::Canvas)
    remove_imgui_drawing_item.(canvas.items)
    empty!(canvas.items)
end

# others are at Desktop/Windows/imgui_drawings.jl
function remove_imgui_drawing_item
end

# module Poptart.Controls
