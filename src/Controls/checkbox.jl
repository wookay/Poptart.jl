# module Poptart.Controls

@UI Checkbox

function properties(control::Checkbox)
    (properties(super(control))..., :text, :active, )
end

# module Poptart.Controls
