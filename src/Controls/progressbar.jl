# module Poptart.Controls

@UI ProgressBar

function properties(control::ProgressBar)
    (properties(super(control))..., :value, :max, :modifyable, )
end

# module Poptart.Controls
