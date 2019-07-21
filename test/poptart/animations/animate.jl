module test_poptart_animations_animate

using Test
using Poptart.Animations

n = 1
a1 = animate() do dt
    global n
    n += 1
end
repeat(a1, 5)

@test haskey(Animations.chronicle.tasks, a1.id)
@test Animations.chronicle.repeatable[a1.id] == 4

end # module test_poptart_animations_animate
