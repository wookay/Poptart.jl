using Revise, Jive
using Poptart
using GLFW

close_window_before_revise = true

trigger = function(path)
    printstyled("changed ", color=:cyan)
    println(path)
    if close_window_before_revise
        glwin = GLFW.GetCurrentContext()
        glwin.handle !== C_NULL && GLFW.SetWindowShouldClose(glwin, true)
    end
    revise()
    runtests(@__DIR__, targets=ARGS, skip=["revise.jl"])
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

glwin = GLFW.GetCurrentContext()
GLFW.SetWindowPos(glwin, 0, 0)

Base.JLOptions().isinteractive==0 && wait()
