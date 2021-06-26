module Desktop # Poptart

export Application, Window
export Button, InputText, Label, Slider, Checkbox, Popup, OpenPopup
export Canvas
export ScatterPlot, Spy, BarPlot, LinePlot, MultiLinePlot, Histogram
export Separator, SameLine, NewLine, Spacing, Group
export MenuBar, Menu, MenuItem
export Mouse, didClick
export pause, resume
export RGBA

using CImGui
using ImGuiGLFWBackend: ImGuiGLFWBackend, LibGLFW
using ImGuiOpenGLBackend: ImGuiOpenGLBackend, ModernGL
using .CImGui: igNewFrame, igRender, igGetIO, igDestroyContext, ImGuiConfigFlags_ViewportsEnable
using .ModernGL: glViewport, glClearColor, glClear, GL_COLOR_BUFFER_BIT
using Colors: RGBA
using Base: @kwdef
using ..Drawings: Drawing, TextBox, ImageBox

abstract type UIApplication end
abstract type UIWindow end
abstract type UIControl end

"""
    Desktop.exit_on_esc()
"""
exit_on_esc() = false

"""
    Desktop.custom_fonts(::Application)
"""
custom_fonts(::Any) = nothing

include("Desktop/controls.jl")
include("Desktop/layouts.jl")
include("Desktop/imgui_convert.jl")
include("Desktop/plots.jl")
include("Desktop/imgui_controls.jl")
include("Desktop/imgui_drawings.jl")
include("Desktop/menus.jl")
include("Desktop/events.jl")
include("Desktop/popups.jl")

env = Dict{ImGuiOpenGLBackend.Context, UIApplication}()
include("Desktop/glfw.jl") # env exit_on_esc
include("Desktop/window.jl")
include("Desktop/application.jl") # env custom_fonts

include("deprecated/Desktop.jl")

end # module Poptart.Desktop
