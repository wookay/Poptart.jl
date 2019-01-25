# module Poptart.Controls

@UI Label

function properties(control::Label)
    (properties(super(control))..., :text, )
end

# module Poptart.Controls
