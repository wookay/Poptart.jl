# module Poptart.Controls

"""
    CheckBox(; text::String, active::Ref, [frame])
"""
CheckBox

@UI CheckBox

function properties(control::CheckBox)
    (properties(super(control))..., :text, :active, )
end

# module Poptart.Controls
