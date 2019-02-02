# module Poptart.Controls

"""
    Canvas(elements = []; props...)
"""
Canvas

@UI Canvas quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    container::Container

    function Canvas(elements = []; props...)
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}(), Container(elements))
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
