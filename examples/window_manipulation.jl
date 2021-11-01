using Poptart.Desktop

Desktop.exit_on_esc() = true

window0 = Window(title="Main", show_window_closing_widget=false)
window1 = Window(title="Win1")
window2 = Window(title="Win2", show_window_closing_widget=false)

app = Application(windows = [window0, window1, window2])

btn1 = Button(title="win1")
btn2 = Button(title="win2")

push!(window0.items, btn1, btn2)

didClick(btn1) do event
    if isopen(window1)
        close(window1)
    else
        open(window1)
    end
end

didClick(btn2) do event
    if isopen(window2)
        close(window2)
    else
        open(window2)
    end
end

!isinteractive() && wait(app.closenotify)
