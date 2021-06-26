# module Poptart.Desktop

using .LibGLFW: glfwGetCurrentContext, glfwMakeContextCurrent, glfwGetFramebufferSize, glfwSwapBuffers, glfwWindowShouldClose, glfwPollEvents, glfwDestroyWindow, glfwSetWindowTitle, glfwSetWindowSize, glfwSetKeyCallback, glfwSetWindowShouldClose, glfwWaitEventsTimeout, GLFWwindow, GLFW_FALSE, GLFW_PRESS, GLFW_KEY_ESCAPE

function custom_key_callback(window::Ptr{GLFWwindow}, key::Cint, scancode::Cint, action::Cint, mods::Cint)::Cvoid
    exit_on_esc() && action == GLFW_PRESS && key == GLFW_KEY_ESCAPE && glfwSetWindowShouldClose(window, true)
    ImGuiGLFWBackend.ImGui_ImplGlfw_KeyCallback(window, key, scancode, action, mods)
end

function runloop(imgui_ctx, window_ctx, gl_ctx, push_window, app::UIApplication)
    ImGuiGLFWBackend.init(window_ctx)
    ImGuiOpenGLBackend.init(gl_ctx)
    glfwSetKeyCallback(window_ctx.Window, @cfunction(custom_key_callback, Cvoid, (Ptr{GLFWwindow}, Cint, Cint, Cint, Cint)))
    window = ImGuiGLFWBackend.get_window(window_ctx)
    try
        quantum = 0.016666666f0
        bgcolor = nothing
        function refresh() 
            bgcolor = app.props[:bgcolor]
        end
        refresh()
        while glfwWindowShouldClose(window) == GLFW_FALSE
            yield()
            glfwWaitEventsTimeout(quantum)
            ImGuiOpenGLBackend.new_frame(gl_ctx)
            ImGuiGLFWBackend.new_frame(window_ctx)
            igNewFrame()

            push_window(app)

            igRender()
            if app.dirty
                refresh()
                app.dirty = false
            end
            glClearColor(bgcolor.r, bgcolor.g, bgcolor.b, bgcolor.alpha)
            glClear(GL_COLOR_BUFFER_BIT)
            ImGuiOpenGLBackend.render(gl_ctx)
            if unsafe_load(igGetIO().ConfigFlags) & ImGuiConfigFlags_ViewportsEnable == ImGuiConfigFlags_ViewportsEnable
                backup_current_context = glfwGetCurrentContext()
                igUpdatePlatformWindows()
                GC.@preserve gl_ctx igRenderPlatformWindowsDefault(C_NULL, pointer_from_objref(gl_ctx))
                glfwMakeContextCurrent(backup_current_context)
            end

            glfwSwapBuffers(window)
        end
    catch e
        @error "Error in renderloop!" exception=e
        Base.show_backtrace(stderr, catch_backtrace())
    finally
        ImGuiOpenGLBackend.shutdown(gl_ctx)
        ImGuiGLFWBackend.shutdown(window_ctx)
        igDestroyContext(imgui_ctx)
        glfwDestroyWindow(window)
        delete!(env, gl_ctx)
        notify(app.closenotify)
    end
end # function runloop()

function create_window(app)
    imgui_ctx = CImGui.igCreateContext(C_NULL)
    window_ctx = ImGuiGLFWBackend.create_context()
    gl_ctx = ImGuiOpenGLBackend.create_context()
    (imgui_ctx, window_ctx, gl_ctx)
end

# module Poptart.Desktop
