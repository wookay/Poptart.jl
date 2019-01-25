# Poptart.jl 🏂

GUI programming in Julia based on [Nuklear.jl](https://github.com/Gnimuc/Nuklear.jl)

```julia
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider didClick

window1 = Windows.Window(title="A", frame=(x=10,y=20,width=200,height=200))
window2 = Windows.Window(title="B", frame=(x=220,y=20,width=200,height=200))
windows = [window1, window2]
Application(windows=windows, title="App", frame=(width=430, height=300))

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
    @info :didClick (event, slider1.value)
end
```

<img src="https://wookay.github.io/docs/Poptart.jl/assets/poptart/app.png" width="500" alt="app.png" />


### Requirements

`julia>` type `]` key

```julia
(v1.0) pkg> add https://github.com/wookay/Poptart.jl
```
