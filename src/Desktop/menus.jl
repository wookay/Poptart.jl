# module Poptart.Desktop

"""
    MenuBar(; menus::Vector)
"""
@kwdef mutable struct MenuBar <: UIControl
    menus::Vector = []
end

"""
    Menu(; title::String, items::Vector)
"""
@kwdef mutable struct Menu <: UIControl
    title::String
    items::Vector = []
end

"""
    MenuItem(; title::String, [shortcut], [selected], [enabled])
"""
@kwdef mutable struct MenuItem <: UIControl
    title::String
    shortcut = C_NULL
    selected::Bool = false
    enabled::Bool = true
end


function imgui_control_item(imctx::Ptr, item::MenuBar)
    if CImGui.BeginMenuBar()
        imgui_control_item.(Ref(imctx), item.menus) # :menus
        CImGui.EndMenuBar()
    end
end

function imgui_control_item(imctx::Ptr, item::Menu)
    if CImGui.BeginMenu(item.title) # :title
        imgui_control_item.(Ref(imctx), item.items) # :items
        CImGui.EndMenu()
    end
end

function imgui_control_item(imctx::Ptr, item::MenuItem)
    title = item.title # :title
    shortcut = get_prop(item, :shortcut)
    selected = get_prop(item, :selected)
    enabled = get_prop(item, :enabled)
    ref_selected = Ref(selected)
    CImGui.MenuItem(item.title, shortcut, ref_selected, enabled) && @async Mouse.leftClick(item)
end

# module Poptart.Desktop
