module test_nuklear_create_context

using Test
using Nuklear.LibNuklear

ctx = nk_create_context()
GC.@preserve ctx begin
    @test Bool(nk_init_default(ctx, C_NULL))
    nk_free(ctx)
end

end # module test_nuklear_create_context
