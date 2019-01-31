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

end # module test_poptart_drawings_canvas
