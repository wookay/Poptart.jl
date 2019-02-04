# module Poptart.Controls

"""
    MenuItem(; callback::Function, label::String, align)
"""
MenuItem

@UI MenuItem

function properties(control::MenuItem)
    (properties(super(control))..., :callback, :label, :align, )
end

"""
    Menu(; text::String, align, row_width, frame::NamedTuple{(:width,:height)})
"""
Menu

@UI Menu quote
    menu_items::Vector{MenuItem}
    function Menu(menu_items::Vector{MenuItem}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, menu_items)
    end
end

function properties(control::Menu)
    (properties(super(control))..., :text, :align, :row_width, )
end

"""
    MenuBar(menu::Vector{<:UIControl}; show::Bool, height)
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
    (properties(super(control))..., :show, :height, )
end

# module Poptart.Controls
