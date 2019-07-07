module test_poptart_controls_button

using Test
using Poptart.Controls # Button UIControl Mouse willSet didSet willSend didSend didClick

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

didClick(button) do event
    push!(observered, (didClick, event))
end

button.frame = (x=1, y=2, width=10, height=20)
@test observered == [(willSet, (x = 1, y = 2, width = 10, height = 20)),
                     (didSet, (x = 1, y = 2, width = 10, height = 20))]
@test button.frame == (x=1, y=2, width=10, height=20)
empty!(observered)

Mouse.leftClick(button)
Mouse.rightClick(button)
Mouse.doubleClick(button)
@test observered == [(willSend, (action = Mouse.leftClick,)),
                     (didSend, (action = Mouse.leftClick,)),
                     (didClick, (action = Mouse.leftClick,)),
                     (willSend, (action = Mouse.rightClick,)),
                     (didSend, (action = Mouse.rightClick,)),
                     (willSend, (action = Mouse.doubleClick,)),
                     (didSend, (action = Mouse.doubleClick,))]

end # module test_poptart_controls_button
