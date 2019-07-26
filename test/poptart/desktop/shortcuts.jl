module test_poptart_desktop_shortcuts

using Poptart.Desktop.Shortcuts # Ctrl Alt Shift Space Key didPress

didPress(Ctrl + Key('f')) do event
end

didPress(Space) do event
end

end # module test_poptart_desktop_shortcuts
