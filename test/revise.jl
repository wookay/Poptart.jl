using Revise, Jive
using Poptart
using GLFW

close_window_before_revise = false

watch(@__DIR__, sources=[pathof(Poptart)]) do path
    @info :changed path
    if close_window_before_revise
        glwin = GLFW.GetCurrentContext()
        glwin.handle !== C_NULL && GLFW.SetWindowShouldClose(glwin, true)
    end
    revise()
    runtests(@__DIR__, targets=ARGS, skip=["revise.jl"])
end
# Jive.stop(watch)
