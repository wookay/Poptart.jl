# module Poptart.Controls

"""
    Label(; text::String, alignment=NK_TEXT_LEFT, color::Union{Nothing,RGBA}=nothing, [frame])
"""
Label

@UI Label quote
    function Label(; text::String, alignment=NK_TEXT_LEFT, color::Union{Nothing,RGBA}=nothing, kwargs...)
        props = Dict{Symbol, Any}(:text => text, :alignment => alignment, :color => color, pairs(kwargs)...)
        new(props, Dict{Symbol, Vector}())
    end
end

"""
    SelectableLabel(; text::String, selected::Ref)
"""
SelectableLabel

@UI SelectableLabel

function properties(control::Label)
    (properties(super(control))..., :text, :alignment, :color, )
end

function properties(control::SelectableLabel)
    (properties(super(control))..., :text, :selected)
end

# module Poptart.Controls
