# module Poptart.Controls

@UI Canvas quote
    container::Container

    function Canvas(; props...)
        new(Dict{Symbol, Any}(props...), Dict{Symbol, Vector}(), Container([]))
    end
end

function properties(control::Canvas)
    (properties(super(control))..., )
end

function Base.put!(canvas::Canvas, elements...)
    push!(canvas.container.items, elements...)
end

# module Poptart.Controls
