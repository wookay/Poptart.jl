using Poptart
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
    ],
)
