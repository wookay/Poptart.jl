# module Poptart.Controls

"""
    Slider(; range, value::Ref)
"""
Slider

@UI Slider

function properties(control::Slider)
    (properties(super(control))..., :range, :value, )
end

# module Poptart.Controls
