# module Poptart.Controls

using ..Drawings

@UI Canvas quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    container::Container

    function Canvas(; props...)
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}(), Container([]))
    end
end

function properties(control::Canvas)
    (properties(super(control))..., )
end

function Base.put!(canvas::Canvas, elements::Drawings.Drawing...)
    push!(canvas.container.items, elements...)
end

# module Poptart.Controls
