# module Poptart.Controls

"""
    Slider(; label::String, range, value, [frame])
"""
Slider

@UI Slider

function properties(control::Slider)
    (properties(super(control))..., :label, :range, :value, )
end

# module Poptart.Controls
