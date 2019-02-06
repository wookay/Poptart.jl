# module Poptart.Controls

"""
    TreeItem(widgets::Vector{<:UIControl} = UIControl[]; tree_type=NK_TREE_TAB, title;;String, state=NK_MINIMIZED)
"""
TreeItem

@UI TreeItem quote
    widgets::Vector{<:UIControl}
    function TreeItem(widgets::Vector{<:UIControl} = UIControl[]; tree_type=NK_TREE_TAB, title::String, state=NK_MINIMIZED, kwargs...)
        props = Dict{Symbol, Any}(:tree_type => tree_type, :title => title, :state => state, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::TreeItem)
    (properties(super(control))..., :tree_type, :title, :state, )
end

# module Poptart.Controls
