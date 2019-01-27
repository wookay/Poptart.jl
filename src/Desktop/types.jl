# module Poptart.Desktop

abstract type UIApplication end
abstract type UIWindow end

mutable struct ApplicationMain <: UIApplication
    props
    windows::Vector{W} where {W <: UIWindow}
    nk_ctx
    task
end

struct Container
    items
end

struct Window <: UIWindow
    container
    props

    function Window(items = []; props...)
        container = Container(items)
        new(container, props)
    end
end

# module Poptart.Desktop
