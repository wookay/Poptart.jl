using Revise, Jive
using Poptart
using GLFW

close_window_before_revise = false

watch(@__DIR__, sources=[pathof(Poptart)]) do path
    @info :changed path
    if close_window_before_revise
        win = GLFW.GetCurrentContext()
        win.handle !== C_NULL && ccall((:glfwSetWindowShouldClose, GLFW.lib), Cvoid, (GLFW.Window, Cint), win, 189)
    end
    revise()
    runtests(@__DIR__, targets=ARGS, skip=["revise.jl"])
end
# Jive.stop(watch)
