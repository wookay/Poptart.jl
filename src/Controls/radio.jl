# module Poptart.Controls

@UI Radio

function properties(control::Radio)
    (properties(super(control))..., :options, :value, )
end

# module Poptart.Controls
