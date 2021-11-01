# Poptart.jl 🏂

|  **Documentation**                        |  **Build Status**                                                  |
|:-----------------------------------------:|:------------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][actions-img]][actions-url]  [![][codecov-img]][codecov-url]  |


GUI programming in Julia based on [CImGui.jl](https://github.com/Gnimuc/CImGui.jl)

 * ☕️   You can [make a donation](https://wookay.github.io/donate/) to support this project.


### Poptart.Desktop

 * Button, Slider

```julia
using Poptart.Desktop # Application Window Button Label Slider didClick

window1 = Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Window(title="B", frame=(x=220,y=20,width=200,height=200))
app = Application(windows=[window1, window2], title="App", frame=(width=430, height=300))

button = Button(title="Hello")
push!(window1.items, button)

label = Label(text="Range:")
slider1 = Slider(label="slider1", range=1:10, value=5)
slider2 = Slider(label="slider2", range=1.0:10.0, value=2.0)
push!(window2.items, label, slider1, slider2)

didClick(button) do event
    @info :didClick event
end

didClick(slider1) do event
    @info :didClick (event, slider1.value)
end

didClick(slider2) do event
    @info :didClick (event, slider2.value)
end

Desktop.exit_on_esc() = true
!isinteractive() && wait(app.closenotify)
```

![slider.png](https://wookay.github.io/docs/Poptart.jl/assets/poptart/slider.png)

 * InputText

```julia
using Poptart.Desktop # Application Window InputText Button didClick

window1 = Window()
app = Application(windows = [window1])

input1 = InputText(label="Subject", buf="")
button1 = Button(title = "submit")
push!(window1.items, input1, button1)

didClick(button1) do event
    @info :didClick (event, input1.buf)
end

Desktop.exit_on_esc() = true
!isinteractive() && wait(app.closenotify)
```

![inputtext.png](https://wookay.github.io/docs/Poptart.jl/assets/poptart/inputtext.png)

* see more examples: [PoptartExamples.jl](https://github.com/wookay/PoptartExamples.jl/tree/master/examples)


[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/Poptart.jl/

[actions-img]: https://github.com/wookay/Poptart.jl/workflows/CI/badge.svg
[actions-url]: https://github.com/wookay/Poptart.jl/actions

[codecov-img]: https://codecov.io/gh/wookay/Poptart.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/wookay/Poptart.jl/branch/master
