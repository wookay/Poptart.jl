module test_poptart_controls

using Test
using Poptart.Controls # UIControl Button Slider willSet didSet willSend didSend

button = Button()
@test button isa UIControl

observered = []

willSet(button, :title) do title
    push!(observered, (willSet, title))
end

didSet(button, :title) do title
    push!(observered, (didSet, title))
end

willSend(button) do event
    push!(observered, (willSend, event))
end

didSend(button) do event
    push!(observered, (didSend, event))
end

button.frame = (x=1, y=2, width=10, height=20)
@test button.frame == (x=1, y=2, width=10, height=20)


slider = Slider(range=1:10)
willSet(slider, :value) do value
    push!(observered, (willSet, value))
end
didSet(slider, :value) do value
    push!(observered, (didSet, value))
end
slider.value = 2
@test slider.value == 2

@test observered == [(willSet, (x = 1, y = 2, width = 10, height = 20)),
                     (didSet, (x = 1, y = 2, width = 10, height = 20)),
                     (willSet, 2),
                     (didSet, 2)]

end # module test_poptart_controls
