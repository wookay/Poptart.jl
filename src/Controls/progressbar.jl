# module Poptart.Controls

"""
    ProgressBar(; value::Ref, max::nk_size, modifyable::Bool, [frame])
"""
ProgressBar

@UI ProgressBar

function properties(control::ProgressBar)
    (properties(super(control))..., :value, :max, :modifyable, )
end

# module Poptart.Controls
