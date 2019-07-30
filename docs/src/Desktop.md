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
```@autodocs
Modules = [Poptart.Desktop.Windows]
```

# Desktop.Shortcuts
```@autodocs
Modules = [Poptart.Desktop.Shortcuts]
```
