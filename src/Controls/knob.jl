# module Poptart.Controls

"""
    Knob(; label::String, range, value, [frame])
"""
Knob

@UI Knob

function properties(control::Knob)
    (properties(super(control))..., :label, :range, :value, )
end

# module Poptart.Controls
