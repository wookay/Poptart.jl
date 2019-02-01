using Jive
@skip module test_glfw_window

using Test
using GLFW

glwin = GLFW.GetCurrentContext()
if glwin.handle === C_NULL
    w = GLFW.CreateWindow(640, 480, "GLFW.jl")
    GLFW.MakeContextCurrent(w)
    GLFW.SwapBuffers(w)
    GLFW.PollEvents()
    w.handle !== C_NULL && GLFW.SetWindowShouldClose(w, true)
    @test GLFW.WindowShouldClose(w)
    GLFW.DestroyWindow(w)
    w = GLFW.GetCurrentContext()
    @test w.handle === C_NULL
end

end # module test_glfw_window
