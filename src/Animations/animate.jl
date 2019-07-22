# module Poptart.Animations

"""
    animate(f; timing::CubicBezier=Linear, duration::Union{<:Real,<:Period}=Second(1))::Animator
"""
function animate(f; timing::CubicBezier=Linear, duration::Union{<:Real,<:Period}=Second(1))::Animator
    # http://graphics.cs.ucdavis.edu/education/CAGDNotes/Matrix-Cubic-Bezier-Curve.pdf
    M = [ 1  0  0  0;
         -3  3  0  0;
          3 -6  3  0;
         -1  3 -3  1]
    P = [timing.p1; timing.p2; timing.p3; timing.p4]
    MP = M * P
    Q(t) = first([1 t t^2 t^3] * MP)
    d = Float64(duration)
    task = function (f_time, chronicle_time)
        elapsed = chronicle_time - f_time
        if elapsed > d
            Δt = 1
            state = nothing
        else
            Δt = Q(elapsed / d)
            state = (phase=1,)
        end
        f(Δt)
        state
    end
    f_time = time()
    id = hash(f_time + first(rand(1)))
    chronicle.tasks[id] = (f_time, task)
    Animator(id, task)
end

"""
    lerp(a, b, dt)
"""
function lerp(a, b, dt)
    a + dt * (b - a)
end

"""
    repeat(animator::Animator, r::Real)
"""
function Base.repeat(animator::Animator, r::Real)
    if r > 0
        chronicle.repeatable[animator.id] = r - 1
        if !haskey(chronicle.tasks, animator.id)
            chronicle.tasks[animator.id] = (time(), animator.task)
        end
    elseif haskey(chronicle.repeatable, animator.id)
        delete!(chronicle.repeatable, animator.id)
    end
    nothing
end

# module Poptart.Animations
