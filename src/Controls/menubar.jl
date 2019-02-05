# module Poptart.Controls

"""
    MenuItem(; callback::Function, label::String, align=NK_TEXT_LEFT)
"""
MenuItem

@UI MenuItem quote
    function MenuItem(; align=NK_TEXT_LEFT, kwargs...)
        props = Dict{Symbol, Any}(:align => align, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers)
    end
end

function properties(control::MenuItem)
    (properties(super(control))..., :callback, :label, :align, )
end

"""
    Menu(; text::String, align, row_width, size::NamedTuple{(:width,:height)})
"""
Menu

@UI Menu quote
    menu_items::Vector{MenuItem}
    function Menu(menu_items::Vector{MenuItem}; align=NK_TEXT_LEFT, kwargs...)
        props = Dict{Symbol, Any}(:align => align, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, menu_items)
    end
end

function properties(control::Menu)
    (properties(super(control))..., :text, :align, :row_width, :size, )
end

"""
    MenuBar(menu::Vector{<:UIControl}; show::Bool, row_height)
"""
MenuBar

@UI MenuBar quote
    menu::Vector{Menu}
    function MenuBar(menu::Vector{Menu}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, menu)
    end
end

function properties(control::MenuBar)
    (properties(super(control))..., :show, :row_height, )
end

# module Poptart.Controls
