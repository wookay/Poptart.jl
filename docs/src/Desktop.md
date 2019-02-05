### Poptart.Desktop

```@docs
Application
Desktop.put!(app::A, windows::UIWindow...) where {A <: UIApplication}
Desktop.remove!(app::A, windows::UIWindow...) where {A <: UIApplication}
```

### Poptart.Desktop.Windows
```@docs
Windows.Window
Windows.put!(window::W, controls::UIControl...) where {W <: UIWindow}
Windows.remove!(window::W, controls::UIControl...) where {W <: UIWindow}
```

### Poptart.Desktop.Themes
```@docs
Desktop.Themes.WhiteTheme
Desktop.Themes.DarkTheme
Desktop.Themes.color_table
Desktop.Themes.set_style!
```
