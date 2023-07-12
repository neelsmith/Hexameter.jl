
"""Determine possible metrical valiue for each syllable in a Vector of string values, `v`. Possible values for each syllable are returned as a Vector of one or more of `LONG`, `SHORT`, and `SYNIZESIS`.
$(SIGNATURES)
# Examples
```jldoctest
julia> scoresyllables(["μη", "νιν"])
2-element Vector{Vector{Int64}}:
 [2]
 [2, 1]
```
"""
function scoresyllables(v; ortho = literaryGreek())
    optionsmap = Vector{Int64}[]
    for (i, s) in  enumerate(v)
        syll = string(s)
        # total consonants at end of this syllable and beginning of next:
        conscount = i < length(v) ? closingcons(syll) + openingcons(v[i + 1]) : closingcons(syll)
        
        if liquidcluster(syll)
            push!(optionsmap, [LONG, SHORT])

        elseif conscount == 0 
            if PolytonicGreek.longsyllable(syll, ortho)
                push!(optionsmap, [LONG, SYNIZESIS])
            else
                push!(optionsmap, [LONG, SHORT, SYNIZESIS])
            end

        elseif conscount > 1
            push!(optionsmap, [LONG] )

        elseif conscount == 1 && shortvowel(syll, ortho = ortho)
            push!(optionsmap, [SHORT])

        elseif PolytonicGreek.longsyllable(syll, ortho)
            push!(optionsmap, [LONG])

        else
            
            push!(optionsmap, [LONG, SHORT])
        end
        
    end
    optionsmap
end
