module test_poptart_desktop_shortcuts

using Poptart.Desktop.Shortcuts # Shift Ctrl Alt Super Key didPress
using .Shortcuts: Space

didPress(Ctrl + Key('f')) do event
end

didPress(Space) do event
end

end # module test_poptart_desktop_shortcuts
