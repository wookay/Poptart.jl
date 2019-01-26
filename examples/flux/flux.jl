# julia -i flux.jl

using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider didClick
using Flux, Test, Random, Statistics, Random

title = "Flux"
window1 = Windows.Window(title=title, frame=(x=10,y=20,width=250,height=200))
windows = [window1]
Application(windows=windows, title=title, frame=(width=430, height=300))

button = Button(title="""test Flux""", frame=(width=220, height=30))
put!(window1, button)

didClick(button) do event
    @info "Testing $title..."
    Random.seed!(0)
    dir = normpath(pathof(Flux), "..", "..", "test")
    include(normpath(dir, "utils.jl"))
    include(normpath(dir, "onehot.jl"))
    @info "ok."
end

Base.JLOptions().isinteractive==0 && wait()
