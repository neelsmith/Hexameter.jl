module Hexameter

using Unicode
using Orthography, PolytonicGreek

using CitableBase, CitableCorpus

using Documenter, DocStringExtensions

export stichos
export hexameter

include("constants.jl")
include("characters.jl")
include("syllables.jl")
include("scoring.jl")
include("stichos.jl")
include("papakitzos.jl")

end # module Hexameter
