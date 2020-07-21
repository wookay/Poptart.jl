using Poptart.Desktop # Application Window InputText Button didClick

window1 = Window()
app = Application(windows = [window1])

input1 = InputText(label="Subject", buf="")
button1 = Button(title = "submit")
push!(window1.items, input1, button1)

didClick(button1) do event
    @info :didClick (event, input1.buf)
end

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
