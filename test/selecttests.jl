using Pkg
Pkg.activate("..")


using Hexameter
using Orthography, PolytonicGreek

using Test
using TestSetExtensions

@testset "All the tests" begin
    println(map(s -> replace(s, r".jl$" => ""), ARGS))
    @includetests map(s -> replace(s, r".jl$" => ""), ARGS)
end
