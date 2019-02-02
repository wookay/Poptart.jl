# module Poptart.Controls

"""
    ToolTip(; text::String, [frame])
"""
ToolTip

@UI ToolTip

function properties(control::ToolTip)
    (properties(super(control))..., :text, )
end

# module Poptart.Controls
