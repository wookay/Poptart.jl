module test_poptart_desktop_shortcuts

using Test
using Poptart.Desktop.Shortcuts # Shift Ctrl Alt Super Key didPress Space
using .Shortcuts: Conjunction

events = []

didPress(Ctrl + Key('F')) do event
    push!(events, event.pressed)
end

didPress(Space) do event
    push!(events, event.pressed)
end

Shortcuts.press(Ctrl + Key('F'))
Shortcuts.press(Space)

Shortcuts.press(Ctrl)
Shortcuts.press(Ctrl + Alt)
Shortcuts.press(Key('F'))
Shortcuts.press(Key('G'))

@test events == [Conjunction(false, true, false, false, Key('F')), Key(' ')]

end # module test_poptart_desktop_shortcuts
