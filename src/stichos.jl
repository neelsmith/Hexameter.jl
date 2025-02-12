
"""Parse the metrical of a string representing a single hexameter.
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
    currline = ""

    # Within this if, every branch must either fail,
    # recurse, or return a final vlue
    @info("From footcount $(ftcount)", currline, length(quantsv), join(textv,","))
    
    if ftcount == 6 && isempty(quantsv)
        @info("At 6 feet: $(inprogress)")
        currline = inprogress

    elseif length(quantsv) == 1 
        @info("FAILED: widowed syllable at ", quantsv, textv, currline)
       
    elseif length(quantsv) == 2
        currline = inprogress * "|" * join(textv[end-1:end], "-") * "|"
        currsolutions = solutions
        @info("Adding final two syllables withouth checking: $(textv[end-1:end]) attached to $(currline)")
        push!(currsolutions, currline)
        popfoot([], [], currsolutions, currline, ftcount + 1)
        
    elseif ftcount < 6
        # More to process
        nxt2 = popn(quantsv, textv, 2)
        @debug("Popped 2: ", nxt2)
        if ! isempty(nxt2)
            currline = join([inprogress, join(textv[1:2],"-")], "|")
            currsolutions = solutions
            @info("Recurse popping 2 (spondee) with", currline, solutions)
            popfoot(quantsv[3:end], textv[3:end], currsolutions, currline, ftcount + 1)
        end
        
        if length(quantsv) > 2
            nxt3 = popn(quantsv, textv, 3)
            if ! isempty(nxt3)
                currline = join([inprogress, join(textv[1:3],"-")], "|")
                currsolutions = solutions
                @info("Recurse popping 3 (dactyl or spondee with elision) with", currline, solutions)
                popfoot(quantsv[4:end], textv[4:end], currsolutions, currline, ftcount + 1)
            end
            
        end 
        if length(quantsv) > 3
            nxt4 = popn(quantsv, textv, 4)
            if ! isempty(nxt4)
                currline = join([inprogress, join(textv[1:4],"-")], "|")
                currsolutions = solutions
                @info("Recurse popping 4 (dactyl with elision) with", currline, solutions)
                popfoot(quantsv[5:end], textv[5:end], currsolutions, currline, ftcount + 1)
            end
        end 
    else # we've reached 6 feet!
        @debug("Returning", currsolutions |> unique)
        currsolutions = unique(solutions)
    end
    currsolutions
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
        
        if sum(args) == 4 && length(quantsv) > n
            @info("With n=$(n), got sum of 4 with $(args): $(textv[1:n])")
            opens_long =  Hexameter.LONG in quantsv[1]
            next_long = Hexameter.LONG in quantsv[n+1]
    
            # Tests to apply:
            if ! next_long #shortvowel(textv[n+1])
                @info("FAIL: this would cause next foot to start with short syllable $(textv[n+1])")
            elseif ! opens_long
                @info("FAIL: this would start foot with short syllable $(textv[1])")
               
            else
                @info("SAVING $(textv[1:n])")
                poppable = textv[1:n]
               
            end
        end
    end
    poppable
end
