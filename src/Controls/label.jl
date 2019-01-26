# module Poptart.Controls

@UI Label
@UI SelectableLabel

function properties(control::Label)
    (properties(super(control))..., :text, )
end

function properties(control::SelectableLabel)
    (properties(super(control))..., :text, :selected)
end

# module Poptart.Controls
