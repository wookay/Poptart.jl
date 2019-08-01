# module Poptart.Drawings

function scale(tup::Tuple{T,T}, x::Real) where {T <: Real}
    scale(tup, (x, x))
end

function scale(tup::Tuple{T,T}, (x, y)) where {T <: Real}
    transform(tup, *, (x, y))
end

function translate(tup::Tuple{T,T}, x::Real) where {T <: Real}
    translate(tup, (x, x))
end

function translate(tup::Tuple{T,T}, (x, y)) where {T <: Real}
    transform(tup, +, (x, y))
end

function transform(tup::Tuple{T,T}, f, (x, y))::Tuple{T,T} where {T <: Real}
    broadcast(f, tup, (x, y))
end


function scale(tup::Tuple{T,T,T,T}, x::Real) where {T <: Real}
    scale(tup, (x, x))
end

function scale(tup::Tuple{T,T,T,T}, (x, y)) where {T <: Real}
    transform(tup, *, (x, y))
end

function translate(tup::Tuple{T,T,T,T}, x::Real) where {T <: Real}
    translate(tup, (x, x))
end

function translate(tup::Tuple{T,T,T,T}, (x, y)) where {T <: Real}
    transform(tup, +, (x, y))
end

function transform(tup::Tuple{T,T,T,T}, f, (x, y))::Tuple{T,T,T,T} where {T <: Real}
    a = broadcast(f, tup[1:2], (x, y))
    b = broadcast(f, tup[3:4], (x, y))
    tuple(a..., b...)
end

# module Poptart.Drawings
