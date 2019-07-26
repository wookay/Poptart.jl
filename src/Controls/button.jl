# module Poptart.Controls

"""
    Button(; title::String, [frame::NamedTuple{(:width,:height)}])
"""
Button

@UI Button

function properties(control::Button)
    (properties(super(control))..., :block, :title, )
end

function Button(f::Function; kwargs...)
    Button(; block=f, kwargs...)
end

# module Poptart.Controls
