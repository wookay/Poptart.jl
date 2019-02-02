# module Poptart.Controls

"""
    Button(; title::String, [frame])
"""
Button

@UI Button

function properties(control::Button)
    (properties(super(control))..., :title,)
end

# module Poptart.Controls
