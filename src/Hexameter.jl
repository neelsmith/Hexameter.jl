module Hexameter

using Unicode
using Orthography, PolytonicGreek

using Documenter, DocStringExtensions

export stichos

include("constants.jl")
include("characters.jl")
include("syllables.jl")
include("stichos.jl")

end # module Hexameter
