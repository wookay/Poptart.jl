# module Poptart.Controls

"""
    Slider(; label::String, range::Union{<:AbstractRange, Tuple, <:NamedTuple}, value)
"""
Slider

@UI Slider

function properties(control::Slider)
    (properties(super(control))..., :label, :range, :value, )
end

# module Poptart.Controls
