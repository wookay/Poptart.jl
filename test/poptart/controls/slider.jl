module test_poptart_controls_slider

using Test
using Poptart.Controls # Slider willSet didSet

slider = Slider(range=1:10, value=1)

observered = []

willSet(slider, :value) do value
    push!(observered, (willSet, value))
end

didSet(slider, :value) do value
    push!(observered, (didSet, value))
end

slider.value = 2
@test observered == [(willSet, 2),
                     (didSet, 2)]
@test slider.value == 2

end # module test_poptart_controls_slider
