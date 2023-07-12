@testset "Test parsing hexameter lines" begin
    analyses = stichos("ἡρώων αὐτοὺς δὲ ἑλώρια τεῦχε κύνεσσιν")
    split(analysis, "|")

    @test length(analyses) == 1
    feet = split(analyses[1], "|")
    
end