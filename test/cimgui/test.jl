module test_cimgui_test

using Test
using CImGui

ctx = CImGui.CreateContext()
@test ctx isa Ptr
CImGui.DestroyContext(ctx)

end # module test_cimgui_test
