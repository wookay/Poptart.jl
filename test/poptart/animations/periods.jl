module test_poptart_animations_periods

using Test
using Dates

@test Millisecond(1000) == Second(1)
@test Nanosecond(1000_000) == Millisecond(1)

using Poptart.Animations

@test Millisecond(1) == Second(0.001)
@test Nanosecond(1) == Millisecond(0.000_001)

@test Float64(Nanosecond(500_000_000)) == 0.5
@test Float64(Millisecond(500)) == 0.5
@test Float64(Second(0.5)) == 0.5
@test Float64(Second(5)) == 5

end # module test_poptart_animations_periods
