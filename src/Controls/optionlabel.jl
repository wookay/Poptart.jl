# module Poptart.Controls

@UI OptionLabel

function properties(control::OptionLabel)
    (properties(super(control))..., :options, :value, )
end

# module Poptart.Controls
