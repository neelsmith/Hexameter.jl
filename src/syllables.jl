
"""Add digamma to standard consonants from literary Greek orthography.
$(SIGNATURES)
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


"""Count number of opening consonants in string `s`.
$(SIGNATURES)


# Examples
```jldoctest
julia> openingcons("μῆνιν")
1
```
"""
function openingcons(s)
    codepts =  graphemes(s) |> collect
    conscount = 0
    i = 0
    done = false
    while  ! done
        i = i + 1
        if i > length(s)
            done = true
        end
        @debug("Test ", codepts[i])
        if occursin(codepts[i], consonants(lg))
            conscount = conscount + 1
        else
            done = true
        end
    end
    conscount
end
