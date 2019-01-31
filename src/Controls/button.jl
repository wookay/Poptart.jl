# module Poptart.Controls

"""
    Button(; title::String, frame::NamedTuple{(:width, :height)})
"""
Button

@UI Button

function properties(control::Button)
    (properties(super(control))..., :title,)
end

# module Poptart.Controls
