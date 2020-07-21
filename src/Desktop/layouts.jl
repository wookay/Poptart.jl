# module Poptart.Desktop

abstract type LayoutElement <: UIControl end

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
@kwdef mutable struct Group <: UIControl
    items::Vector{Union{<:LayoutElement, <:UIControl}} = []
end


function imgui_control_item(imctx::Ptr, item::Group)
    CImGui.BeginGroup()
    imgui_control_item.(Ref(imctx), item.items) # :items
    CImGui.EndGroup()
end

function imgui_control_item(imctx::Ptr, item::Separator)
    CImGui.Separator()
end

function imgui_control_item(imctx::Ptr, item::SameLine)
    CImGui.SameLine()
end

function imgui_control_item(imctx::Ptr, item::NewLine)
    CImGui.NewLine()
end

function imgui_control_item(imctx::Ptr, item::Spacing)
    CImGui.Spacing()
end

# module Poptart.Desktop
