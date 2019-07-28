# module Poptart.Controls

"""
    MenuBar
"""
MenuBar

@UI MenuBar

function properties(control::MenuBar)
    (properties(super(control))..., :menus, )
end

"""
    Menu
"""
Menu

@UI Menu

function properties(control::Menu)
    (properties(super(control))..., :title, :items, )
end

"""
    MenuItem
"""
MenuItem

@UI MenuItem

function properties(control::MenuItem)
    (properties(super(control))..., :title, :shortcut, :selected, :enabled, )
end

# module Poptart.Controls
