# Poptart.jl 🏂

|  **Documentation**                        |  **Build Status**                                                                                  |
|:-----------------------------------------:|:--------------------------------------------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][travis-img]][travis-url]  [![][appveyor-img]][appveyor-url]  [![][codecov-img]][codecov-url] |


GUI programming in Julia based on [Nuklear.jl](https://github.com/Gnimuc/Nuklear.jl)

 * ☕️   You can [make a donation](https://wookay.github.io/donate/) to support this project.


### Poptart.Controls

```julia
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Button Label Slider didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=220,y=20,width=200,height=200))
Application(windows=[window1, window2], title="App", frame=(width=430, height=300))

button = Button(title="Hello", frame=(width=80, height=30))
put!(window1, button)

label = Label(text="Range:")
slider1 = Slider(range=1:10, value=Ref{Cint}(5))
slider2 = Slider(range=1.0:10.0, value=Ref{Cfloat}(2.0))
put!(window2, label, slider1, slider2)

didClick(button) do event
    @info :didClick event
end

didClick(slider1) do event
    @info :didClick (event, slider1.value[])
end
```

<img src="https://wookay.github.io/docs/Poptart.jl/assets/poptart/app.png" width="500" alt="app.png" />


### Poptart.Drawings

```julia
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Canvas
using Poptart.Drawings # Line Rect Circle Triangle Arc Curve Polyline Polygon stroke fill
using Colors: RGBA

canvas = Canvas()
window1 = Windows.Window(items=[canvas], title="Drawings", frame=(x=0, y=0, width=500, height=400))
Application(windows=[window1], title="App", frame=(width=500, height=400))

strokeColor = RGBA(0,0.7,0,1)
fillColor   = RGBA(0.1, 0.7,0.8,0.9)

line1 = Line(points=[(50, 100), (90, 140)], thickness=7.5, color=strokeColor)
line2 = Line(points=[(60, 90), (100, 130)], thickness=7.5, color=strokeColor)
line3 = Line(points=[(70, 80), (110, 120)], thickness=7.5, color=strokeColor)

rect2 = Rect(rect=(160, 70, 50, 50), rounding=0, color=fillColor)
rect1 = Rect(rect=(160, 150, 50, 50), rounding=0, thickness=7.5, color=strokeColor)

circle2 = Circle(rect=(160+70, 70, 51, 51), color=fillColor)
circle1 = Circle(rect=(160+70, 150, 51, 51), thickness=7.5, color=strokeColor)

triangle2 = Triangle(points=[(320, 75), (300,116), (340,116)], color=fillColor)
triangle1 = Triangle(points=[(320, 75+80), (300,116+80), (340,116+80)], thickness=7.5, color=strokeColor)

arc2 = Arc(center=(380, 80), radius=37, angle=(min=0, max=deg2rad(120)), color=fillColor)
arc1 = Arc(center=(380, 80+80), radius=37, angle=(min=0, max=deg2rad(120)), thickness=7.5, color=strokeColor)

m(x, y) = (x, y) .+ (-340, -20)
curve1 = Curve(startPoint=m(380,200), control1=m(405,270), control2=m(455,120), endPoint=m(480,200), thickness=7.5, color=strokeColor)

polyline1 = Polyline(points=[(320-60, 75+150), (300-60,116+150), (340-60,116+150)], thickness=7.5, color=strokeColor)

polygon1 = Polygon(points=[(320, 75+150), (300,116+150), (340,116+150)], thickness=7.5, color=strokeColor)
polygon2 = Polygon(points=[(320, 75+220), (300,116+220), (340,116+220)], color=fillColor)

put!(canvas,
    stroke.((line1, line2, line3))...,
    stroke(rect1), fill(rect2),
    stroke(circle1), fill(circle2),
    stroke(triangle1), fill(triangle2),
    stroke(arc1), fill(arc2),
    stroke(curve1),
    stroke(polyline1),
    stroke(polygon1), fill(polygon2))
```

<img src="https://wookay.github.io/docs/Poptart.jl/assets/poptart/drawings.png" width="500" alt="drawings.png" />


### Requirements

`julia>` type `]` key

```julia
(v1.0) pkg> add https://github.com/wookay/Poptart.jl
```


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/Poptart.jl/

[travis-img]: https://api.travis-ci.org/wookay/Poptart.jl.svg?branch=master
[travis-url]: https://travis-ci.org/wookay/Poptart.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/69br6a0jnr2dnr5b?svg=true
[appveyor-url]: https://ci.appveyor.com/project/wookay/poptart-jl

[codecov-img]: https://codecov.io/gh/wookay/Poptart.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/Poptart.jl/branch/master
