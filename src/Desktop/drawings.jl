# module Poptart.Desktop

using ..Drawings
using .Drawings: DrawingElement

function Base.pop!(items::Vector{Union{Drawings.ImageBox, Drawings.TextBox, Drawings.Drawing}}, elements...)
    drawing_elements = convert.(Drawings.Drawing, elements)
    indices = filter(x -> x !== nothing, indexin(drawing_elements, items))
    deleteat!(items, indices)
    remove_imgui_drawing_item.(elements)
    nothing
end

# module Poptart.Desktop
