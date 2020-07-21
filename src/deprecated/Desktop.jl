# module Poptart.Desktop

export Windows
export put!, remove!


module Windows # Poptart.Desktop
using ..Desktop: Window
end # module Poptart.Desktop.Windows

function Base.put!(window::Windows.Window, items...)
    push!(window.items, items...)
end

function Base.put!(canvas::Canvas, items...)
    push!(canvas.items, items...)
end

function remove!(canvas::Canvas, elements...)
    pop!(canvas.items, elements...)
end

# module Poptart.Desktop
