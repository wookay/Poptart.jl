# module Poptart.Controls

"""
    Slider(; range, value::Ref, [frame])
"""
Slider

@UI Slider

function properties(control::Slider)
    (properties(super(control))..., :range, :value, )
end

# module Poptart.Controls
