module test_colors_rgba

using Test
using Colors

@test RGBA(colorant"red", 1) == RGBA(1,0,0,1)

c = RGBA(1,0,0,0.5)
@test round.(Int, 0xff .* (c.r,c.g,c.b,c.alpha)) == (255, 0, 0, 128)

end # module test_colors_rgba
