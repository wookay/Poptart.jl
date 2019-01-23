# module Poptart.Controls

@UI Slider

function properties(control::Slider)
    (properties(super(control))..., :range, :value, )
end

# module Poptart.Controls
