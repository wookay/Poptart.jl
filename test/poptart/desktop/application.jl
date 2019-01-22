module test_poptart_desktop_application

using Test
using Poptart.Desktop # Application put!
using Poptart.Controls # UIControl Button Slider

app = Application()

button = Button(title="Hello", frame=(x=1, y=2, width=10, height=20))
slider = Slider(range=1:10, value=2, frame=(x=1, y=100, width=20, height=20))

didSend(button) do event
end

put!(app.window, slider)

@test app.window isa Desktop.Window

end # module test_poptart_desktop_application
