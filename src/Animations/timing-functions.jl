# module Poptart.Animations

abstract type TimingFunction <: Function end

"""
    struct CubicBezier <: TimingFunction
        p1::Float64
        p2::Float64
        p3::Float64
        p4::Float64
    end
"""
struct CubicBezier <: TimingFunction
    p1::Float64
    p2::Float64
    p3::Float64
    p4::Float64
end

"""
    const Ease = CubicBezier(0.25, 0.1, 0.25, 1.0)
"""
const Ease = CubicBezier(0.25, 0.1, 0.25, 1.0)

"""
    const Linear = CubicBezier(0.0, 0.0, 1.0, 1.0)
"""
const Linear = CubicBezier(0.0, 0.0, 1.0, 1.0)

"""
    const EaseIn = CubicBezier(0.42, 0, 1.0, 1.0)
"""
const EaseIn = CubicBezier(0.42, 0, 1.0, 1.0)

"""
    const EaseOut = CubicBezier(0, 0, 0.58, 1.0)
"""
const EaseOut = CubicBezier(0, 0, 0.58, 1.0)

"""
    const EaseInOut = CubicBezier(0.42, 0, 0.58, 1.0)
"""
const EaseInOut = CubicBezier(0.42, 0, 0.58, 1.0)

# module Poptart.Animations
