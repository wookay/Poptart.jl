# module Poptart.Controls

"""
    Label(; text::String)
"""
Label

@UI Label

"""
    SelectableLabel(; text::String, selected::Ref)
"""
SelectableLabel

@UI SelectableLabel

function properties(control::Label)
    (properties(super(control))..., :text, )
end

function properties(control::SelectableLabel)
    (properties(super(control))..., :text, :selected)
end

# module Poptart.Controls
