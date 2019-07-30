# module Poptart.Controls

"""
    Knob(; range::Union{<:AbstractRange, Tuple, <:NamedTuple}, [value], [label::String], [num_segments], [thickness], [frame])
"""
Knob

@UI Knob

function properties(control::Knob)
    (properties(super(control))..., :range, :value, :label, :num_segments, :thickness, )
end

# module Poptart.Controls
