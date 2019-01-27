# module Poptart.Desktop

function Base.put!(window::W, controls...) where {W <: UIWindow}
    push!(window.container.items, controls...)
end

# module Poptart.Desktop
