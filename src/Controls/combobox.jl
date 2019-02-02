# module Poptart.Controls

"""
    ComboBox(; options, value, [frame])
"""
ComboBox

@UI ComboBox

function properties(control::ComboBox)
    (properties(super(control))..., :options, :value, )
end

# module Poptart.Controls
