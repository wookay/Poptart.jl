# module Poptart.Desktop

"""
    InputText(; label::String = "", buf::String = "", buf_size::Int = 32)
"""
@kwdef mutable struct InputText <: UIControl
    label::String = ""
    buf::String = ""
    buf_size::Int = 32
end

"""
    Button(; title::String = "Button", callback::Union{Nothing,Function} = nothing)
"""
@kwdef mutable struct Button <: UIControl
    title::String = "Button"
    callback::Union{Nothing,Function} = nothing
    frame::NamedTuple{(:width, :height)} = (width=0, height=0) # deprecated
end

"""
    Label(; text::String)
"""
@kwdef mutable struct Label <: UIControl
    text::String
end

"""
    Slider(; label::String = "", range::Union{<:AbstractRange, Tuple, <:NamedTuple}, value)
"""
@kwdef mutable struct Slider <: UIControl
    label::String = ""
    range::Union{<:AbstractRange, Tuple, <:NamedTuple}
    value
    callback::Union{Nothing,Function} = nothing
end

"""
    Canvas(; items::Vector{Drawing}} = Drawing[])
"""
@kwdef mutable struct Canvas <: UIControl
    items::Vector{Drawing} = Drawing[]
end

# module Poptart.Desktop
