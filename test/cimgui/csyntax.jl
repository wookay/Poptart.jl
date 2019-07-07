module test_cimgui_csyntax

using Test
using CImGui: CSyntax
using .CSyntax.CStatic # @cstatic

animate, arr = @cstatic animate=true arr=Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2] begin
end # @cstatic

@test animate
@test arr == Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2]

end # module test_cimgui_csyntax
