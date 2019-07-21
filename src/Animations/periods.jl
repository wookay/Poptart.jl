# module Poptart.Animations

using Dates: Period, Second, Millisecond, Nanosecond
using Printf: @sprintf

function Second(t::Float64)
    Millisecond(t * 1000)
end

function Millisecond(t::Float64)
    Nanosecond(t * 1000_000)
end

function Base.:(*)(n::Float64, t::Nanosecond)
    Nanosecond(round(Int, n * t.value))
end

function Base.:(*)(t::Nanosecond, n::Float64)
    Nanosecond(round(Int, n * t.value))
end

function Float64(t::Nanosecond)
    t.value / 1_000_000_000
end

function Float64(t::Millisecond)
    t.value / 1_000
end

function Float64(t::Second)
    Float64(t.value)
end

function Base.show(io::IO, mime::MIME"text/plain", t::Nanosecond)
    if t.value >= 1_000_000
        milli = t.value / 1_000_000
        print(io, iszero(t.value % 1_000_000) ? @sprintf("%.0f", milli) : @sprintf("%.1f", milli))
        print(io, " milliseconds")
    else
        print(io, t.value, " nanoseconds")
    end 
end

# module Poptart.Animations
