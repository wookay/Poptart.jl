using Poptart
using Poptart.Desktop
using .Desktop: UIApplication
using Poptart.Drawings
using Documenter

makedocs(
    build = joinpath(@__DIR__, "local" in ARGS ? "build_local" : "build"),
    modules = [Poptart],
    clean = false,
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        assets = ["assets/custom.css"],
    ),
    sitename = "Poptart.jl 🏂",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
        "Desktop" => "Desktop.md",
        "Drawings" => "Drawings.md",
    ],
)
