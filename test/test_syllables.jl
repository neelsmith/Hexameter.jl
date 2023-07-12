@testset "Test counting opening and closing patterns" begin
    @test Hexameter.openingcons("μῆ") == 1
    @test Hexameter.closingcons("μῆ") == 0
    @test Hexameter.closingcons("ἐξ") == 2
    @test Hexameter.isopen("μῆ")
end

@testset "Test scoring possible metrical values" begin
    syllables = syllabify("μῆνιν", literaryGreek())
    # ι could be long or short.
    expectedscores = [[Hexameter.LONG], [Hexameter.LONG, Hexameter.SHORT]]
    actualscores = Hexameter.scoresyllables(syllables)
    @test actualscores == expectedscores

    # context aware: allow for synizesis when next syllable
    # starts with a vowel
    sylls = syllabify("ἡρώων, αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν", literaryGreek())
    scores = Hexameter.scoresyllables(sylls)
    @test (sylls[1], scores[1]) == ( "ἡ", [Hexameter.LONG])
    @test (sylls[2], scores[2]) == ( "ρω", [Hexameter.LONG, Hexameter.SYNIZESIS])

    # make sure double consonants count as two syllables
    @test Hexameter.scoresyllables(["ἐξ"]) == [[Hexameter.LONG]]

end

@testset "Test identifying length of vowels and metrical length of syllables" begin
    
    @test Hexameter.shortvowel("δὲ")
    @test Hexameter.shortvowel("δή") == false
end
