module test_poptart_drawings_transform

using Test
using Poptart.Drawings # Line Rect RectMultiColor Circle Triangle TextBox ImageBox translate scale translate! scale!
using Colors: RGBA

@test translate((1, 1), (1,2)) == (2, 3)
@test scale((1, 1), (1, 2)) == (1, 2)

@test translate.([(1, 1), (2, 2)], Ref((1, 2))) == [(2, 3), (3, 4)]
@test scale.([(1, 1), (2, 2)], Ref((1, 2))) == [(1, 2), (2, 4)]

line1 = Line(points=[(50, 100), (90, 140)])
triangle1 = Triangle(points=[(320, 75), (300,116), (340,116)])
quad1 = Quad(points=[(320, 75), (300,116), (340,116+40), (380, 116)])
polyline1 = Polyline(points=[(320-60, 75+150), (300-60,116+150), (340-60,116+150)])
polygon1 = Polygon(points=[(320, 75+150), (300,116+150), (340,116+150)])

translate!(line1, (1, 1))
@test line1.points ==  map(x -> x .+ 1, [(50, 100), (90, 140)])
scale!(line1, (2, 2))
@test line1.points ==  map(x -> (x .+ 1) .* 2, [(50, 100), (90, 140)])

translate!(triangle1, (1, 1))
@test triangle1.points == map(x -> x .+ 1, [(320, 75), (300,116), (340,116)])
scale!(triangle1, (2, 2))
@test triangle1.points ==  map(x -> (x .+ 1) .* 2, [(320, 75), (300,116), (340,116)])

translate!(quad1, (1, 1))
@test quad1.points == map(x -> x .+ 1, [(320, 75), (300,116), (340,116+40), (380, 116)])
scale!(quad1, (2, 2))
@test quad1.points ==  map(x -> (x .+ 1) .* 2, [(320, 75), (300,116), (340,116+40), (380, 116)])

translate!(polyline1, (1, 1))
@test polyline1.points == map(x -> x .+ 1, [(320-60, 75+150), (300-60,116+150), (340-60,116+150)])
scale!(polyline1, (2, 2))
@test polyline1.points == map(x -> (x .+ 1) .* 2, [(320-60, 75+150), (300-60,116+150), (340-60,116+150)])

translate!(polygon1, (1, 1))
@test polygon1.points == map(x -> x .+ 1, [(320, 75+150), (300,116+150), (340,116+150)])
scale!(polygon1, (2, 2))
@test polygon1.points == map(x -> (x .+ 1) .* 2, [(320, 75+150), (300,116+150), (340,116+150)])

circle1 = Circle(center=(100, 200), radius=25)
arc1 = Arc(center=(100, 200), radius=25, angle=(min=0, max=deg2rad(120)))
pie1 = Pie(center=(100, 200), radius=25, angle=(min=0, max=deg2rad(120)))

translate!(circle1, (1, 1))
@test circle1.center == (100, 200) .+ 1
scale!(circle1, 2)
@test circle1.radius == 25 * 2

translate!(arc1, (1, 1))
@test arc1.center == (100, 200) .+ 1
scale!(arc1, 2)
@test arc1.radius == 25 * 2

translate!(pie1, (1, 1))
@test pie1.center == (100, 200) .+ 1
scale!(pie1, 2)
@test pie1.radius == 25 * 2

curve1 = Curve(startPoint=(100, 200), control1=(110, 210), control2=(120, 220), endPoint=(130, 230))

translate!(curve1, (1, 1))
@test curve1.startPoint == (100, 200) .+ 1
@test curve1.control1 == (110, 210) .+ 1
@test curve1.control2 == (120, 220) .+ 1
@test curve1.endPoint == (130, 230) .+ 1
scale!(curve1, (2, 2))
@test curve1.startPoint == ((100, 200) .+ 1) .* 2
@test curve1.control1 == ((110, 210) .+ 1) .* 2
@test curve1.control2 == ((120, 220) .+ 1) .* 2
@test curve1.endPoint == ((130, 230) .+ 1) .* 2

rect1 = Rect(rect=(160, 150, 50, 50))
rectmulticolor1 = RectMultiColor(rect=(160, 150, 50, 50), color_upper_left=RGBA(0,0.7,0.7,1), color_upper_right=RGBA(0.7,0.7,0,1), color_bottom_left=RGBA(0.7,0,0,1), color_bottom_right=RGBA(0,0,0.7,1))
textbox1 = TextBox(text="text", rect=(160, 150, 50, 50))
imagebox1 = ImageBox(image=nothing, rect=(160, 150, 50, 50))

translate!(rect1, (1, 1))
@test rect1.rect == (160, 150, 50, 50) .+ 1
scale!(rect1, (2, 2))
@test rect1.rect == (160+1, 150+1, 2 .* (50+1, 50+1)...)

translate!(textbox1, (1, 1))
@test textbox1.rect == (160, 150, 50, 50) .+ 1
scale!(textbox1, (2, 2))
@test textbox1.rect == (160+1, 150+1, 2 .* (50+1, 50+1)...)

translate!(imagebox1, (1, 1))
@test imagebox1.rect == (160, 150, 50, 50) .+ 1
scale!(imagebox1, (2, 2))
@test imagebox1.rect == (160+1, 150+1, 2 .* (50+1, 50+1)...)

imagebox2 = ImageBox(image=nothing, rect=nothing)
translate!(imagebox2, (1, 1))
@test imagebox2.rect === nothing
scale!(imagebox2, (2, 2))
@test imagebox2.rect === nothing

circle2 = Circle(center=(100, 200))
arc2 = Arc(center=(100, 200), angle=(min=0, max=deg2rad(120)))
pie2 = Pie(center=(100, 200), angle=(min=0, max=deg2rad(120)))
@test circle2.radius == arc2.radius == pie2.radius == 30
scale!(circle2, 2)
scale!(arc2, 2)
scale!(pie2, 2)
@test circle2.radius == arc2.radius == pie2.radius == 30 * 2

end # module test_poptart_drawings_transform
