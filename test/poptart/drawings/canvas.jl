module test_poptart_drawings_canvas

using Test
using Poptart.Controls # Canvas
using Poptart.Drawings # Line stroke
using Colors # RGBA

canvas = Canvas()
@test canvas isa UIControl

line = Line(points=[(0, 1), (0, 1)], thickness=1, color=RGBA(1,0,0,1))
put!(canvas, stroke(line))
@test first(canvas.container.items) isa Drawings.Drawing{stroke}

color1 = RGBA(0,0.7,0,1)
circle1 = Circle(rect=(160+70, 150, 51, 51), thickness=7.5, color=color1)
@test (stroke ∘ fill)(circle1) == Drawings.Drawing{Drawings.stroke_and_fill}(circle1)

end # module test_poptart_drawings_canvas
