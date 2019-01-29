module test_colors_rgba

using Test
using Colors

@test RGBA(colorant"red", 1) == RGBA(1,0,0,1)

c = RGB(1,0,0)
@test 0xff .* (c.r,c.g,c.b) == (255, 0, 0)

end # module test_colors_rgba
