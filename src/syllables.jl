"""True is vowel in syllable `s` can only be short.
$(SIGNATURES)
NB: Currently this function only works with the `LiteraryGreekOrthography`
implementation of `GreekOrthography`.
# Examples
```jldoctest
julia> shortvowel("δὲ")
true
```
"""
function shortvowel(s; ortho = literaryGreek())
    noacc = rmaccents(s, ortho)
    vowel = PolytonicGreek.vowelsonly(noacc, ortho)
    occursin(vowel, PolytonicGreek.LG_SHORTVOWELS)
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
        if isconsonant(codepts[i])
            conscount = conscount + 1
        else
            done = true
        end
    end
    conscount
end


"""Count number of closing consonants in `s`.
$(SIGNATURES)
# Examples
```jldoctest
julia> closingcons("μῆνιν")
1
```
"""
function closingcons(s)
    codepts =  graphemes(s) |> collect
    conscount = 0
    i = length(codepts)
    done = false
    
    while  ! done
        @debug("Test cp", codepts[i])
        if i == 0
            done = true
        elseif isconsonant(codepts[i])
            conscount = conscount + 1
        else
            done = true
        end
        i = i - 1
    end
    conscount
end


"""True if syllable `s` is an open syllable.
$(SIGNATURES)
# Examples
```jldoctest
julia> isopen("μῆ")
true
```
"""
function isopen(s)
    closingcons(s) == 0
end

"""True if `s` ends in a cluster of plosive + liquid.

"""
function liquidcluster(s)
    #@warn("liquidcluster: NOT YET IMPLEMENTED.")
    false
end


"""Determine possible metrical valiue for each syllable in a Vector of string values, `v`. Possible values for each syllable are returned as a Vector of one or more of `LONG`, `SHORT`, and `CORREPTION`.
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

        elseif conscount > 1
            push!(optionsmap, [LONG] )

        elseif conscount == 0 
            if PolytonicGreek.longsyllable(syll, ortho)
                push!(optionsmap, [LONG, CORREPTION])
            else
                push!(optionsmap, [LONG, SHORT, CORREPTION])
            end

        elseif PolytonicGreek.longsyllable(syll, ortho)
            push!(optionsmap, [LONG])
        else
            push!(optionsmap, [LONG, SHORT])
        end
        
    end
    optionsmap
end



