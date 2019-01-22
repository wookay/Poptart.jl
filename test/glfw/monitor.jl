module test_glfw_monitor

using Test
using GLFW

monitors = GLFW.GetMonitors()
if isempty(monitors)
    @info :empty monitors
else
    monitor = GLFW.GetPrimaryMonitor()
    @test monitor isa GLFW.Monitor
    @test GLFW.GetMonitorPos(monitor) == (x = 0, y = 0)
    @test keys(GLFW.GetMonitorPhysicalSize(monitor)) == (:width, :height)
    @test !isempty(GLFW.GetVideoModes(monitor))
    @test !isempty(GLFW.GetMonitorName(monitor))
    mode = GLFW.GetVideoMode(monitor)
    @test mode.refreshrate >= 0
end

end # module test_glfw_monitor
