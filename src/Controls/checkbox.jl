# module Poptart.Controls

@UI CheckBox

function properties(control::CheckBox)
    (properties(super(control))..., :text, :active, )
end

# module Poptart.Controls
