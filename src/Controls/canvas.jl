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
    put!(canvas::Canvas, elements::Drawings.Drawing...)
"""
function Base.put!(canvas::Canvas, elements::Drawing...)
    push!(canvas.container.items, elements...)
end

# module Poptart.Controls
