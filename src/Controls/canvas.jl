# module Poptart.Controls

"""
    Canvas(; items::Vector{<:Drawing} = Drawing[], [frame])
"""
Canvas

@UI Canvas quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    items::Vector{<:Drawing}

    function Canvas(; items::Vector{<:Drawing} = Drawing[], kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, items)
    end
end

function properties(control::Canvas)
    (properties(super(control))..., )
end

"""
    Controls.put!(canvas::Canvas, elements::Union{Drawing, TextBox}...)
"""
function put!(canvas::Canvas, elements::Union{Drawing, TextBox}...)
    drawing_elements = convert.(Drawing, elements)
    push!(canvas.items, drawing_elements...)
    nothing
end

"""
    Controls.remove!(canvas::Canvas, elements::Union{Drawing, TextBox}...)
"""
function remove!(canvas::Canvas, elements::Union{Drawing, TextBox}...)
    drawing_elements = convert.(Drawing, elements)
    indices = filter(x -> x !== nothing, indexin(drawing_elements, canvas.items))
    deleteat!(canvas.items, indices)
    nothing
end

"""
    empty!(canvas::Canvas)
"""
function Base.empty!(canvas::Canvas)
    empty!(canvas.items)
end

# module Poptart.Controls
