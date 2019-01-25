# module Poptart.Desktop

function Base.put!(window::Windows.Window, controls...)
    push!(window.container.items, controls...)
end

# module Poptart.Desktop
