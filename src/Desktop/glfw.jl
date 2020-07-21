# module Poptart.Desktop

error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"

function custom_key_callback(window::GLFW.Window, key, scancode, action, mods)
    exit_on_esc() && action == GLFW.PRESS && key == GLFW.KEY_ESCAPE && GLFW.SetWindowShouldClose(window, true)
    GLFWBackend.ImGui_ImplGlfw_KeyCallback(window, key, scancode, action, mods)
end

function runloop(glwin, ctx, glsl_version, push_window, app::UIApplication)
    GLFWBackend.ImGui_ImplGlfw_InitForOpenGL(glwin, true)
    OpenGLBackend.ImGui_ImplOpenGL3_Init(glsl_version)
    GLFW.SetKeyCallback(glwin, custom_key_callback)
    GLFW.SetErrorCallback(error_callback)
    try
        quantum = 0.016666666f0
        bgcolor = nothing
        function refresh() 
            bgcolor = app.props[:bgcolor]
        end
        refresh()
        while !GLFW.WindowShouldClose(glwin)
            yield()
            GLFW.WaitEvents(quantum)
            OpenGLBackend.ImGui_ImplOpenGL3_NewFrame()
            GLFWBackend.ImGui_ImplGlfw_NewFrame()
            CImGui.NewFrame()
            push_window(app)
            CImGui.Render()
            display_w, display_h = GLFW.GetFramebufferSize(glwin)
            ModernGL.glViewport(0, 0, display_w, display_h)
            if app.dirty
                refresh()
                app.dirty = false
            end
            ModernGL.glClearColor(bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.alpha)
            ModernGL.glClear(ModernGL.GL_COLOR_BUFFER_BIT)
            OpenGLBackend.ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())
            GLFW.SwapBuffers(glwin)
        end
    catch e
        @error "Error in renderloop!" exception=e
        Base.show_backtrace(stderr, catch_backtrace())
    finally
        OpenGLBackend.ImGui_ImplOpenGL3_Shutdown()
        GLFWBackend.ImGui_ImplGlfw_Shutdown()
        CImGui.DestroyContext(ctx)
        GLFW.HideWindow(glwin)
        GLFW.DestroyWindow(glwin)
        delete!(env, glwin.handle)
        notify(app.closenotify)
    end
end # function runloop()

function create_window(app, vsync=true)
    @static if Sys.isapple()
        # OpenGL 3.2 + GLSL 150
        glsl_version = 150
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 2)
        GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, ModernGL.GL_TRUE) # required on Mac
    else
        # OpenGL 3.0 + GLSL 130
        glsl_version = 130
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)
        # GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        # GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, ModernGL.GL_TRUE) # 3.0+ only
    end
    window = GLFW.CreateWindow(app.props[:frame].width, app.props[:frame].height, app.props[:title])
    GLFW.MakeContextCurrent(window)
    vsync && GLFW.SwapInterval(1)
    ctx = CImGui.CreateContext()
    (window, ctx, glsl_version)
end

# module Poptart.Desktop
