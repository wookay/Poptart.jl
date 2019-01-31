# module Poptart.Controls

"""
    Checkbox(; text::String, active::Ref)
"""
Checkbox

@UI Checkbox

function properties(control::Checkbox)
    (properties(super(control))..., :text, :active, )
end

# module Poptart.Controls
