# Build docs from root directory of repository:
#
#     julia --project=docs/ docs/make.jl
#
# Serve docs from repository root:
#
#   julia -e 'using LiveServer; serve(dir="docs/build")' 
#
using Pkg
Pkg.activate(".")
Pkg.instantiate()


using Documenter, DocStringExtensions, Hexameter

makedocs(
    sitename = "Hexameter.jl",
    pages = [
        "Overview" => "index.md",
       
        "API documentation" => "api.md"
        ]
    )


deploydocs(
    repo = "github.com/neelsmith/Hexameter.jl.git",
) 