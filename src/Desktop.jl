module Desktop # Poptart

export Application, Window
export Button, InputText, Label, Slider
export Canvas
export ScatterPlot, Spy, BarPlot, LinePlot, MultiLinePlot, Histogram
export Separator, SameLine, NewLine, Spacing, Group
export MenuBar, Menu, MenuItem
export Mouse, didClick
export pause, resume
export RGBA

using CImGui
using .CImGui: GLFWBackend, OpenGLBackend
using .GLFWBackend: GLFW
using .OpenGLBackend: ModernGL
using Colors: RGBA
using Base: @kwdef
using ..Drawings: Drawing, TextBox, ImageBox

abstract type UIApplication end
abstract type UIWindow end
abstract type UIControl end

exit_on_esc() = false
custom_fonts(::Any) = nothing

include("Desktop/controls.jl")
include("Desktop/layouts.jl")
include("Desktop/imgui_convert.jl")
include("Desktop/plots.jl")
include("Desktop/drawings.jl")
include("Desktop/imgui_controls.jl")
include("Desktop/imgui_drawings.jl")
include("Desktop/menus.jl")
include("Desktop/events.jl")

env = Dict{Ptr{Cvoid},UIApplication}()
include("Desktop/glfw.jl") # env exit_on_esc
include("Desktop/window.jl")
include("Desktop/application.jl") # env custom_fonts

include("deprecated/Desktop.jl")

end # module Poptart.Desktop
