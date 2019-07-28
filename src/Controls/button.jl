# module Poptart.Controls

"""
    Button(; title::String, [frame::NamedTuple{(:width,:height)}])
"""
Button

@UI Button

function properties(control::Button)
    (properties(super(control))..., :title, )
end

function Button(f::Function; kwargs...)
    Button(; post_block=f, kwargs...)
end

# module Poptart.Controls
