# module Poptart.Controls

@UI Button

function properties(control::Button)
    (properties(super(control))..., :title,)
end

# module Poptart.Controls
