# module Poptart.Controls

"""
    Knob(; label::String, range, value, [num_segments], [thickness], [frame])
"""
Knob

@UI Knob

function properties(control::Knob)
    (properties(super(control))..., :label, :range, :value, :num_segments, :thickness, )
end

# module Poptart.Controls
