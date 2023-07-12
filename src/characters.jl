
"""Add digamma to standard consonants from literary Greek orthography.
$(SIGNATURES)
# Examples
```jldoctest
julia> Hexameter.hexameterconss()
"βγδζθκλμνξπρστφχψςϝ"
```
"""
function hexameterconss()
    consonants(literaryGreek()) * "ϝ"
end

"""True if string `s` is a single consonant.
$(SIGNATURES)

# Examples
```jldoctest
julia> Hexameter.isconsonant("ϝ")
true
```
"""
function isconsonant(s)
    occursin(s, hexameterconss())
end