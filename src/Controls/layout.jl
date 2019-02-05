# module Poptart.Controls

"""
    StaticRow(widgets::Vector{<:UIControl}; row_height, row_width, [cols])
"""
StaticRow

@UI StaticRow quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    widgets::Vector{<:UIControl}
    function StaticRow(widgets::Vector{<:UIControl}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::StaticRow)
    (properties(super(control))..., :row_height, :row_width, :cols, )
end

"""
    DynamicRow(widgets::Vector{<:UIControl}; row_height, [cols])
"""
DynamicRow

@UI DynamicRow quote
    widgets::Vector{<:UIControl}
    function DynamicRow(widgets::Vector{<:UIControl}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::DynamicRow)
    (properties(super(control))..., :row_height, :cols, )
end

"""
    Spacing(widgets::Vector{<:UIControl}; [cols])
"""
Spacing

@UI Spacing quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    widgets::Vector{<:UIControl}
    function Spacing(widgets::Vector{<:UIControl}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::Spacing)
    (properties(super(control))..., :cols, )
end

"""
    Group(widgets::Vector{<:UIControl}=UIControl[]; name::String, title::String="", flags=NK_WINDOW_BORDER, row_height, row_width, [cols])
"""
Group

@UI Group quote
    widgets::Vector{<:UIControl}
    function Group(widgets::Vector{<:UIControl}=UIControl[]; name::String, title::String="", flags=NK_WINDOW_BORDER, kwargs...)
        props = Dict{Symbol, Any}(:name => name, :title => title, :flags => flags, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::Group)
    (properties(super(control))..., :name, :title, :flags, :row_height, :row_width, :cols, )
end

# module Poptart.Controls
