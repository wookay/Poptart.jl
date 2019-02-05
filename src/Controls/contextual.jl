# module Poptart.Controls

"""
    ContextualItem(; callback::Function, label::String, align=NK_TEXT_LEFT)
"""
ContextualItem

@UI ContextualItem quote
    function ContextualItem(; align=NK_TEXT_LEFT, kwargs...)
        props = Dict{Symbol, Any}(:align => align, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers)
    end
end

function properties(control::ContextualItem)
    (properties(super(control))..., :callback, :label, :align, )
end

"""
    Contextual(items::Vector{ContextualItem}; flags=0, size::NamedTuple{(:width,:height)}, [trigger_bounds::NamedTuple{(:x,:y,:width,:height)}])
"""
Contextual

@UI Contextual quote
    items::Vector{ContextualItem}
    function Contextual(items::Vector{ContextualItem}=ContextualItem[]; flags=0, kwargs...)
        props = Dict{Symbol, Any}(:flags => flags, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, items)
    end
end

function properties(control::Contextual)
    (properties(super(control))..., :flags, :size, :trigger_bounds, )
end

# module Poptart.Controls
