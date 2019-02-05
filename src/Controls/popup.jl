# module Poptart.Controls

"""
    Popup(widgets::Vector{<:UIControl}; show::Bool, popup_type=NK_POPUP_STATIC, title::String, flags=NK_WINDOW_CLOSABLE, frame::NamedTuple{(:x,:y,:width,:height)})
"""
Popup

@UI Popup quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    widgets::Vector{<:UIControl}
    function Popup(widgets::Vector{<:UIControl}; popup_type=NK_POPUP_STATIC, flags=NK_WINDOW_CLOSABLE, kwargs...)
        props = Dict{Symbol, Any}(:popup_type => popup_type, :flags => flags, kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::Popup)
    (properties(super(control))..., :show, :popup_type, :title, :flags, )
end

# module Poptart.Controls
