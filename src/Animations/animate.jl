# module Poptart.Animations

# http://graphics.cs.ucdavis.edu/education/CAGDNotes/Matrix-Cubic-Bezier-Curve.pdf
function (q::CubicBezier)(t::Float64)
    M = [ 1  0  0  0;
         -3  3  0  0;
          3 -6  3  0;
         -1  3 -3  1]
    P = [q.p1; q.p2; q.p3; q.p4]
    first([1 t t^2 t^3] * M * P)
end

function Animator(f, timing::CubicBezier, duration::Union{<:Real,<:Period}, repeatable::Real)::Animator
    d = Float64(duration)
    task = function (f_time, chronicle_time)
        elapsed = chronicle_time - f_time
        if elapsed > d
            Δt = 1
            state = nothing
        else
            Δt = timing(elapsed / d)
            state = (phase=1,)
        end
        f(Δt)
        state
    end
    f_time = time()
    id = hash(f_time + first(rand(1)))
    Animator(id, task, repeatable)
end

"""
    animate(f; timing::CubicBezier=Linear, duration::Union{<:Real,<:Period}=Second(1))::Animator
"""
function animate(f; timing::CubicBezier=Linear, duration::Union{<:Real,<:Period}=Second(1))::Animator
    animate(Animator(f, timing, duration, 1))
end

"""
    animate(animator::Animator)::Animator
"""
function animate(animator::Animator)::Animator
    if animator.repeatable > 0
        chronicle.tasks[animator.id] = (time(), animator.task, animator.repeatable)
    elseif haskey(chronicle.tasks, animator.id)
        delete!(chronicle.tasks, animator.id)
    end
    animator
end

"""
    lerp(a, b, dt)
"""
function lerp(a, b, dt)
    a + dt * (b - a)
end

"""
    repeat(animator::Animator, r::Real)::Animator
"""
function Base.repeat(animator::Animator, r::Real)::Animator
    Animator(animator.id, animator.task, r)
end

# module Poptart.Animations
