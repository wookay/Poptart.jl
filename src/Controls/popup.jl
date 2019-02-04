# module Poptart.Controls

"""
    Popup(widgets::Vector{<:UIControl}; show::Bool, popup_type, title::String, flags, frame)
"""
Popup

@UI Popup quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    widgets::Vector{<:UIControl}
    function Popup(widgets::Vector{<:UIControl}; kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, widgets)
    end
end

function properties(control::Popup)
    (properties(super(control))..., :show, :popup_type, :title, :flags, :frame, )
end

# module Poptart.Controls
