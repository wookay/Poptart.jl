# module Poptart.Desktop

function Base.put!(window::Windows.TextWindow, control::C) where {C <: Controls.UIControl}
end

function Base.put!(window::Windows.Window, control::C) where {C <: Controls.UIControl}
    push!(window.container.items, control)
end

# module Poptart.Desktop
