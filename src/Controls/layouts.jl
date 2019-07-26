# module Poptart.Controls

abstract type LayoutElement; end

"""
    Separator
"""
struct Separator <: LayoutElement
end

"""
    SameLine
"""
struct SameLine <: LayoutElement
end

"""
    NewLine
"""
struct NewLine <: LayoutElement
end

"""
    Spacing
"""
struct Spacing <: LayoutElement
end

"""
    Group(; items::Vector{Union{<:LayoutElement, <:UIControl}})
"""
Group

@UI Group

function properties(control::Group)
    (properties(super(control))..., :items, )
end

# module Poptart.Controls
