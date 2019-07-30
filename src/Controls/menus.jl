# module Poptart.Controls

"""
    MenuBar(; menus::Vector)
"""
MenuBar

@UI MenuBar

function properties(control::MenuBar)
    (properties(super(control))..., :menus, )
end

"""
    Menu(; title::String, items::Vector)
"""
Menu

@UI Menu

function properties(control::Menu)
    (properties(super(control))..., :title, :items, )
end

"""
    MenuItem(; title::String, [shortcut], [selected], [enabled])
"""
MenuItem

@UI MenuItem

function properties(control::MenuItem)
    (properties(super(control))..., :title, :shortcut, :selected, :enabled, )
end

# module Poptart.Controls
