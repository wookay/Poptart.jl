using Poptart.Animations: Ease, lerp

using Test

# code form https://developer.roblox.com/en-us/articles/Bezier-curves
function cubicBezier(t, p0, p1, p2, p3)
    l1 = lerp(p0, p1, t)
    l2 = lerp(p1, p2, t)
    l3 = lerp(p2, p3, t)
    a = lerp(l1, l2, t)
    b = lerp(l2, l3, t)
    lerp(a, b, t)
end

# code from http://graphics.cs.ucdavis.edu/education/CAGDNotes/Matrix-Cubic-Bezier-Curve.pdf
M = [ 1  0  0  0;
     -3  3  0  0;
      3 -6  3  0;
     -1  3 -3  1]

timing = Ease

Q1(t) = cubicBezier(t, timing.p1, timing.p2, timing.p3, timing.p4)

P = [timing.p1; timing.p2; timing.p3; timing.p4]
Q2(t) = first([1 t t^2 t^3] * M * P)

for dt in 0.01:0.01:1
    @test Q1(dt) ≈ Q2(dt)
end
