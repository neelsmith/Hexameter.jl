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

"""True if string `s` includes a double consonant
(ζ, ξ, ψ).
$(SIGNATURES)
# Examples
```jldoctest
julia> hasdoublecons("ἐξ")
true
```
"""
function hasdoublecons(s)
    withdouble = false
    for c in ["ζ", "ξ", "ψ"]
        if occursin(c, s)
           withdouble = true
        end
    end
    withdouble 
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
    hasdoublecons(s) ? conscount + 1 : conscount
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
    hasdoublecons(s) ? conscount + 1 : conscount
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




