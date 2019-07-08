using Poptart
using Poptart.Desktop
using Poptart.Desktop.Windows: UIWindow, UIApplication
using Poptart.Controls
using Poptart.Drawings
using Poptart.Drawings: DrawingElement
using Documenter

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = [Poptart],
    clean = false,
    format = Documenter.HTML(),
    sitename = "Poptart.jl 🏂",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
        "Desktop" => "Desktop.md",
        "Controls" => "Controls.md",
        "Drawings" => "Drawings.md",
    ],
)
