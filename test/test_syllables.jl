@testset "Test counting opening and closing patterns" begin
    @test Hexameter.openingcons("μῆ") == 1
    @test Hexameter.closingcons("μῆ") == 0
    @test Hexameter.isopen("μῆ")
end

@testset "Test scoring possible metrical values" begin
    syllables = syllabify("μῆνιν", literaryGreek())
    expectedscores = [[Hexameter.LONG], [Hexameter.LONG, Hexameter.SHORT]]
    actualscores = Hexameter.scoresyllables(syllables)
    @test actualscores == expectedscores
end

@testset "Test identifying length of vowels and metrical length of syllables" begin
    
    @test Hexameter.shortvowel("δὲ")
    @test Hexameter.shortvowel("δή") == false
end
