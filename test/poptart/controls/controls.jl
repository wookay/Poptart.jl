module test_poptart_controls

using Test
using Poptart.Controls # UIControl Button Slider willSet didSet willSend didSend

button = Button()
@test button isa UIControl

willSet(button, :title) do title
end

didSet(button, :title) do title
end

willSend(button) do event
end

didSend(button) do event
end

button.frame = (x=1, y=2, width=10, height=20)


slider = Slider(range=1:10)
slider.value = 2
didSet(slider, :value) do value
end
willSet(slider, :value) do value
end

end # module test_poptart_controls
