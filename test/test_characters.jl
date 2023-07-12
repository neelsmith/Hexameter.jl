
@testset "Test recognizing characters" begin
    expectedconss = "βγδζθκλμνξπρστφχψςϝ"
    @test Hexameter.hexameterconss() == expectedconss

    @test Hexameter.isconsonant("ϝ")
    @test Hexameter.isconsonant("ς")
    @test Hexameter.isconsonant("α") == false


    @test Hexameter.hasdoublecons("ἐξ")

end