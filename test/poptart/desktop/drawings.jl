using Jive
@useinside module test_poptart_desktop_drawings

using Test
using Poptart.Desktop # Application Windows
using Poptart.Controls # Canvas put! remove!
using Poptart.Drawings # Line Rect RectMultiColor Circle Triangle TextBox stroke fill
using Colors: RGBA

canvas = Canvas()
window1 = Windows.Window(items=[canvas], title="Drawings", frame=(x=10, y=10, width=480, height=380))
app = Application(windows=[window1], title="App", frame=(width=500, height=400))

strokeColor = RGBA(0, 0.7, 0, 1)
fillColor   = RGBA(0.1, 0.7, 0.8, 0.9)

line1 = Line(points=[(50, 100), (90, 140)], thickness=7.5, color=strokeColor)
line2 = Line(points=[(60, 90), (100, 130)], thickness=7.5, color=strokeColor)
line3 = Line(points=[(70, 80), (110, 120)], thickness=7.5, color=strokeColor)

rect2 = Rect(rect=(160, 70, 50, 50), rounding=0, color=fillColor)
rect1 = Rect(rect=(160, 150, 50, 50), rounding=0, thickness=7.5, color=strokeColor)

rectmulticolor1 = RectMultiColor(rect=(160, 220, 50, 50), color_upper_left=RGBA(0,0.7,0.7,1), color_upper_right=RGBA(0.7,0.7,0,1), color_bottom_left=RGBA(0.7,0,0,1), color_bottom_right=RGBA(0,0,0.7,1))

centre = (255, 95)
radius = 25
circle1 = Circle(centre=centre .+ (0, 80), radius=radius, thickness=7.5, color=strokeColor)
circle2 = Circle(centre=centre, radius=radius, color=fillColor)

triangle2 = Triangle(points=[(320, 75), (300,116), (340,116)], color=fillColor)
triangle1 = Triangle(points=[(320, 75+80), (300,116+80), (340,116+80)], thickness=7.5, color=strokeColor)

m(x, y) = (x, y) .+ (-340, -20)
curve1 = Curve(startPoint=m(380,200), control1=m(405,270), control2=m(455,120), endPoint=m(480,200), thickness=7.5, color=strokeColor)

# arc1 = Arc(center=(380, 80+80), radius=37, angle=(min=0, max=deg2rad(120)), thickness=7.5, color=strokeColor)
# arc2 = Arc(center=(380, 80), radius=37, angle=(min=0, max=deg2rad(120)), color=fillColor)
# polyline1 = Polyline(points=[(320-60, 75+150), (300-60,116+150), (340-60,116+150)], thickness=7.5, color=strokeColor)
# polygon1 = Polygon(points=[(320, 75+150), (300,116+150), (340,116+150)], thickness=7.5, color=strokeColor)
# polygon2 = Polygon(points=[(320, 75+220), (300,116+220), (340,116+220)], color=fillColor)

put!(canvas,
    stroke.((line1, line2, line3))...,
    stroke(rect1), fill(rect2),
    fill(rectmulticolor1),
    stroke(circle1), fill(circle2),
    stroke(triangle1), fill(triangle2),
    stroke(curve1))

rect3 = Rect(rect=(80, 270, 50, 50), rounding=0, thickness=7.5, color=strokeColor)
stroke1 = stroke(rect3)
put!(canvas, stroke1)
remove!(canvas, stroke1)

end # module test_poptart_desktop_drawings
