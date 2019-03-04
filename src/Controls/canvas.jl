# module Poptart.Controls

"""
    Canvas(elements::Vector{<:Drawing} = Drawing[]; [frame])
"""
Canvas

@UI Canvas quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    container::Container

    function Canvas(elements::Vector{<:Drawing} = Drawing[]; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        container = Container(elements)
        new(props, observers, container)
    end
end

function properties(control::Canvas)
    (properties(super(control))..., )
end

"""
    Controls.put!(canvas::Canvas, elements::Drawings.Drawing...)
"""
function put!(canvas::Canvas, elements::Drawing...)
    push!(canvas.container.items, elements...)
    nothing
end

"""
    Controls.remove!(canvas::Canvas, elements::Drawings.Drawing...)
"""
function remove!(canvas::Canvas, elements::Drawing...)
    indices = filter(x -> x !== nothing, indexin(elements, canvas.container.items))
    deleteat!(canvas.container.items, indices)
    nothing
end

"""
    Base.empty!(canvas::Canvas)
"""
function Base.empty!(canvas::Canvas)
    empty!(canvas.container.items)
end

# module Poptart.Controls
