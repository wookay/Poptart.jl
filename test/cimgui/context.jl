module test_cimgui_context

using Test
using CImGui

imctx = CImGui.CreateContext()
@test imctx isa Ptr

io = CImGui.GetIO()
@test io isa Ptr{CImGui.ImGuiIO}
@test io.DeltaTime == Float32(1/60)

time = CImGui.GetTime()
@test time == 0

CImGui.DestroyContext(imctx)

end # module test_cimgui_context
