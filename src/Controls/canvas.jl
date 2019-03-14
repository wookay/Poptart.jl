# module Poptart.Controls

"""
    Canvas(; items::Vector{<:Drawing} = Drawing[])
"""
Canvas

@UI Canvas quote
    # props::Dict{Symbol, Any}
    # observers::Dict{Symbol, Vector}
    items::Vector{<:Drawing}

    function Canvas(; items::Vector{<:Drawing} = Drawing[], kwargs...)
        props = Dict{Symbol, Any}(kwargs...)
        observers = Dict{Symbol, Vector}()
        new(props, observers, items)
    end
end

function properties(control::Canvas)
    (properties(super(control))..., )
end

"""
    Controls.put!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
"""
function put!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
    drawing_elements = convert.(Drawing, elements)
    push!(canvas.items, drawing_elements...)
    nothing
end

"""
    Controls.remove!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
"""
function remove!(canvas::Canvas, elements::Union{Drawing, TextBox, ImageBox}...)
    drawing_elements = convert.(Drawing, elements)
    indices = filter(x -> x !== nothing, indexin(drawing_elements, canvas.items))
    deleteat!(canvas.items, indices)
    remove_nuklear_drawing_item.(elements)
    nothing
end

"""
    empty!(canvas::Canvas)
"""
function Base.empty!(canvas::Canvas)
    empty!(canvas.items)
end

function remove_nuklear_drawing_item(element::ImageBox)
    if haskey(element.props, :imageref)
        texture_index = element.props[:texture_index]
        imageref = element.props[:imageref]
        delete!(element.props, :texture_index)
        delete!(element.props, :imageref)
        nk_glfw3_delete_texture(texture_index)
    end
end

function remove_nuklear_drawing_item(::Any)
end

# module Poptart.Controls
