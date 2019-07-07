module test_cimgui_context

using Test
using CImGui

ctx = CImGui.CreateContext()
@test ctx isa Ptr

io = CImGui.GetIO()
@test io isa Ptr{CImGui.ImGuiIO}
@test io.DeltaTime == Float32(1/60)

time = CImGui.GetTime()
@test time == 0

CImGui.DestroyContext(ctx)

end # module test_cimgui_context
