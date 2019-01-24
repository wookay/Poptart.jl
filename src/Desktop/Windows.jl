module Windows # Poptart.Desktop

using ..Desktop
using ..Controls

using GLFW
using Nuklear
using Nuklear.LibNuklear
using Nuklear.GLFWBackend
using ModernGL # glViewport

const MAX_VERTEX_BUFFER = 512 * 1024
const MAX_ELEMENT_BUFFER = 128 * 1024

abstract type UIWindow end

struct Container
    items
end

struct Window <: UIWindow
    container
    task

    function Window(; props...)
        container = Container([])
        task = @async setup_window(container)
        @info :task task
        new(container, task)
    end
end

function setup_window(container::Container)
    @static if Sys.isapple()
        VERSION_MAJOR = 3
        VERSION_MINOR = 3
    end

    @static if Sys.isapple()
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, VERSION_MAJOR)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, VERSION_MINOR)
        GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE)
        GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE)
    else
        GLFW.DefaultWindowHints()
    end

    WINDOW_WIDTH  = 400
    WINDOW_HEIGHT = 300
    win = GLFW.CreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Demo")

    GLFW.MakeContextCurrent(win)
    glViewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

    # init context
    ctx = nk_glfw3_init(win, NK_GLFW3_INSTALL_CALLBACKS, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)

    nk_glfw3_font_stash_begin()
    nk_glfw3_font_stash_end()

    EASY = 0
    HARD = 1

    op = EASY
    property = Ref{Cint}(20)
    bg = nk_colorf(0.10, 0.18, 0.24, 1.0)

    while !GLFW.WindowShouldClose(win)
        yield()

        GLFW.PollEvents()
        nk_glfw3_new_frame()

        if Bool(nk_begin(ctx, "Demo", nk_rect(50, 50, 230, 250), NK_WINDOW_BORDER|NK_WINDOW_MOVABLE|NK_WINDOW_SCALABLE| NK_WINDOW_MINIMIZABLE|NK_WINDOW_TITLE))

            for item in container.items
                if item isa Button
                    nk_layout_row_static(ctx, item.frame.height, item.frame.width, 1)
                    if nk_button_label(ctx, item.title) == 1
                        event = (action=Mouse.click,)
                        @async Mouse.click(item, pos=GLFW.GetCursorPos(win))
                    end
                end
            end

        end
        nk_end(ctx)

        # draw
        width, height = GLFW.GetWindowSize(win)
        glViewport(0, 0, width, height)
        glClear(GL_COLOR_BUFFER_BIT)
        glClearColor(bg.r, bg.g, bg.b, bg.a)
        nk_glfw3_render(NK_ANTI_ALIASING_ON, MAX_VERTEX_BUFFER, MAX_ELEMENT_BUFFER)
        GLFW.SwapBuffers(win)
    end
    nk_glfw3_shutdown()
    GLFW.DestroyWindow(win)
end

struct TextWindow <: UIWindow

    function TextWindow(; props...)
        new()
    end
end

end # Poptart.Desktop.Windows
