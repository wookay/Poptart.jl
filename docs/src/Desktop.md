# Poptart.Desktop

Desktop

# Desktop.Application

```@docs
Application
pause(app::A) where {A <: UIApplication}
resume(app::A) where {A <: UIApplication}
Desktop.put!(app::A, windows::UIWindow...) where {A <: UIApplication}
Desktop.remove!(app::A, windows::UIWindow...) where {A <: UIApplication}
empty!(app::A) where {A <: UIApplication}
```

# Desktop.Windows
```@docs
Windows.Window
Windows.put!(window::W, controls::UIControl...) where {W <: UIWindow}
Windows.remove!(window::W, controls::UIControl...) where {W <: UIWindow}
empty!(window::W) where {W <: UIWindow}
```
