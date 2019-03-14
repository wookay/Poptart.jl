using Poptart.Desktop
using Nuklear.GLFWBackend: GLFW, glfw

window1 = Windows.Window(title="Drop Here", frame=(x=10, y=10, width=480, height=380))
Application(windows=[window1], title="App", frame=(width=500, height=400))

function drop_callback(_, paths)
    for path in paths
        (_, ext) = splitext(path)
        ext == ".jl" && include(path)
    end
end
GLFW.SetDropCallback(glfw.win, drop_callback)
