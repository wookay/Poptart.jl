using Poptart.Desktop

window0 = Window(title="Main", show_window_closing_widget=false)
window1 = Window(title="Win1")
window2 = Window(title="Win2", show_window_closing_widget=false)

app = Application(windows = [window0, window1, window2])

btn1 = Button(title="win1")
btn2 = Button(title="win2")

push!(window0.items, btn1, btn2)

didClick(btn1) do event
    if Desktop.isopen(window1)
        CloseWindow(window1)
    else
        OpenWindow(window1)
    end
end

didClick(btn2) do event
    if Desktop.isopen(window2)
        CloseWindow(window2)
    else
        OpenWindow(window2)
    end
end

Base.JLOptions().isinteractive==0 && wait(app.closenotify)
