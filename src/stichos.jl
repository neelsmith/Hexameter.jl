
"""Parse meter of a single hexameter.
$(SIGNATURES)
"""
function stichos(s; ortho = literaryGreek())
    syllables = syllabify(s,ortho)
    scores = scoresyllables(syllables, ortho = ortho)
    popfoot(scores, syllables)# .* string("|", join(lastfoot, "-"))
end

"""Recusively pop one metrical foot of syllables from two parallel 
vectors: `textv`, the vector of syllables for a hexameter, and `quantsv`, the vector of scores for each syllable.
$(SIGNATURES)

Returns a string formatted in convention of pipe character separating feet,
hyphens separating syllables.
"""
function popfoot(quantsv, textv, solutions = [], inprogress = "", ftcount = 0)
    # Return value for final set of solutions:
    currsolutions = solutions
    currline = inprogress

    # Within this if, every branch must either fail,
    # recurse, or return a final vlue
    @info("From footcount $(ftcount)", currline, length(quantsv), join(textv,","))
    if isempty(quantsv)
        #done

    elseif length(quantsv) == 1 
        @debug("FAILED: widowed syllable at ", quantsv, textv, currline)
       
    elseif length(quantsv) == 2
        @debug("Adding final two syllables withouth checking: $(textv[end-1:end]) attached to $(currline)")
        push!(currsolutions, currline * "|" * join(textv[end-1:end], "-") * "|")
   
    #elseif length(quantsv) == 3
     #   @debug("FAILED: last foot must be long+anceps so can't pop a foot when 3 syllables are left ", quantsv, textv, currline)
      
    elseif (ftcount + 1) < 6
        # More to process
        nxt2 = popn(quantsv, textv, 2)
        @info("Popped 2: ", nxt2)
        if ! isempty(nxt2)
            currline = join([inprogress, join(textv[1:2],"-")], "|")
            @info("Recurse popping 2 (spondee) with", currline, solutions)
            popfoot(quantsv[3:end], textv[3:end], currsolutions, currline, ftcount + 1)
        end
        
        if length(quantsv) > 2
            nxt3 = popn(quantsv, textv, 3)
            if ! isempty(nxt3)
                currline = join([inprogress, join(textv[1:3],"-")], "|")
                @info("Recurse popping 3 (dactyl or spondee with elision) with", currline, solutions)
                popfoot(quantsv[4:end], textv[4:end], currsolutions, currline, ftcount + 1)
            end
            
        end 
        if length(quantsv) > 3
            nxt4 = popn(quantsv, textv, 4)
            if ! isempty(nxt4)
                currline = join([inprogress, join(textv[1:4],"-")], "|")
                @info("Recurse popping 4 (dactyl with elision) with", currline, solutions)
                popfoot(quantsv[5:end], textv[5:end], currsolutions, currline, ftcount + 1)
            end
        end 
    else # we've reached 6 feet!
        @debug("Returning", currsolutions |> unique)
        return currsolutions |> unique
    end
end

"""Remove next `n` syllables if metrically allowed.
Otherwise, return an empty array.
$(SIGNATURES)
"""
function popn(quantsv, textv, n)
    poppable = []
    @debug("Popping $(n) with $(quantsv[1:n])")
    loopargs = [[2]]
    for i in 2:n
        push!(loopargs, quantsv[i])
        @debug("Push ", quantsv[i],loopargs)
    end  

    itts = Iterators.product(loopargs...) |> collect
    @debug("Iterate product ", itts)
    for args in Iterators.product(loopargs...)
        
        if sum(args) == 4
            @info("Look at " , textv[1:n])
            # Tests to apply:
            if shortvowel(textv[n+1])
                @info("FAIL: this would cause next foot to start with short syllable $(textv[n+1])")
            elseif ! shortsyllable(textv[1]) #Hexameter.LONG in quantsv[1]
                @info("SAVING $(textv[1:n])")
                poppable = textv[1:n]
            else
                @info("FAIL: this would start foot with short syllable $(textv[1])")
            end
        end
    end
    poppable
end
