@testset "Test counting opening and closing patterns" begin
    @test Hexameter.openingcons("μῆ") == 1
    @test Hexameter.closingcons("μῆ") == 0
    @test Hexameter.isopen("μῆ")
end

@testset "Test scoring possible metrical values" begin
    syllables = syllabify("μῆνιν", literaryGreek())
    Hexameter.scoresyllables(syllables)
end

#=lnpart = "μῆνιν"
"μῆνιν"

julia> syllabify(lnpart, literaryGreek()) |> Hexameter.scoresyllables
┌ Warning: liquidcluster: NOT YET IMPLEMENTED.
└ @ Hexameter ~/Desktop/Hexameter.jl/src/syllables.jl:77
┌ Warning: liquidcluster: NOT YET IMPLEMENTED.
└ @ Hexameter ~/Desktop/Hexameter.jl/src/syllables.jl:77
2-element Vector{Any}:
 [2]
 [2, 1]
=#