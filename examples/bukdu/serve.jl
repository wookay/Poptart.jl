# julia -i serve.jl

# https://github.com/wookay/Bukdu.jl
using Bukdu # routes get Conn render
using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Mouse Button Label Slider didClick

title = "Bukdu"
window1 = Windows.Window(title=title, frame=(x=10,y=20,width=200,height=200))
windows = [window1]
closed = Condition()
Application(windows=windows, title=title, frame=(width=430, height=300), closed=closed)

button = Button(title="Hello", frame=(width=150, height=30))
put!(window1, button)

port = 8080
didClick(button) do event
    if Bukdu.env[:server] === nothing
        button.title = "stop"
        Bukdu.start(port)
    else
        button.title = "Bukdu.start($port)"
        Bukdu.stop()
    end
end

routes() do
    get("/") do conn::Conn
        render(JSON, "Hello")
    end
end

Mouse.leftClick(button)

Base.JLOptions().isinteractive==0 && wait(closed)
