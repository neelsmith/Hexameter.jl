
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

    @debug("From ", currline, length(quantsv), join(textv,","))
    if isempty(quantsv)
        #done

    elseif length(quantsv) == 1 
        @info("FAILED: widowed syllable at ", quantsv, textv, currline)
       

    elseif length(quantsv) == 2
        @info("Adding final two syllables withouth checking: $(textv[end-1:end]) attached to $(currline)")
        push!(currsolutions, currline * "|" * join(textv[end-1:end], "-") * "|")
   

    # May analyze 2, 3 or 4 syllables (spondee, dactyl or spondee + 0, dactyl + 0)
    else # more syllables to analyze
        # Maybe roll these three possibilities off to testable subfunctions.
        # Run this one in any case:
        @debug("Len quantsv", length(quantsv))
        for (i,j) in Iterators.product([2], quantsv[2])
               if i + j == 4
                tval = join([currline, join(textv[1:2],"-")], "|")
                @debug(tval)
                currline = tval
        
               
                # Peek ahead: avoid breaking into foot if next syll
                # has to be short. 
                if shortvowel(textv[3])
                    @info("FAIL: this would cause next foot to start with short syllable $(textv[3]) at $(currline)")
                elseif (ftcount + 1) < 6
                    @debug("CHECK FOOTCOUNT BEFORE RECURSION: $(ftcount + 1)")
                    @info("Recurse popping 2 (spondee) with", currline, currsolutions)
                    # CHECK QUANT OF FIRST SYLL
                    if Hexameter.LONG in quantsv[1]
                        popfoot(quantsv[3:end], textv[3:end], currsolutions, currline, ftcount + 1)
                    else
                        @info("FAIL: this would start a foot with a short at $(currline)")
                    end
                end        
            end
        end
        # Then check the next two possiblities, depending on how much is left:
        if length(quantsv) > 2
            for (i,j,k) in Iterators.product([2], quantsv[2], quantsv[3])
                if sum([i,j,k]) == 4
                    currline = join([inprogress, join(textv[1:3],"-")], "|")
                    if (ftcount + 1) < 6
                        @debug("CHECK FOOTCOUNT BEFORE RECURSION: $(ftcount + 1)")
                       
          
                        
                        # CHECK QUANT OF FIRST SYLL
                        @debug("CHECK QUANT OF FIRST SYLL $(quantsv[1]) for $(textv[1])")
                        @debug("at $(currline)")
                        if Hexameter.LONG in quantsv[1]
                            @info("Recurse popping 3 (dactyl or 0 syllable) with", currline, solutions)
                            popfoot(quantsv[4:end], textv[4:end], currsolutions, currline, ftcount + 1)
                        else
                            @info("FAIL: this would start a foot with a short at $(currline) ")
                        end
                   
                end
                end
            end
        end
        if length(quantsv) > 3
            for (i,j,k,l) in Iterators.product([2], quantsv[2], quantsv[3], quantsv[4])
                if sum([i,j,k]) == 4
                    @info("CANDIDATE 4-SYLL FOOT: $()")
                    currline = join([inprogress, join(textv[1:4],"-")], "|")
                    if (ftcount + 1) < 6
                        @debug("CHECK FOOTCOUNT BEFORE RECURSION: $(ftcount + 1)")
                        @debug("CHECK QUANT OF FIRST SYLL $(quantsv[1]) for $(textv[1])")
                        @debug("at $(currline)")
                        if Hexameter.LONG in quantsv[1]
                            @info("Recurse popping 3 (dactyl or 0 syllable) with", currline, solutions)
                            popfoot(quantsv[5:end], textv[5:end], currsolutions, currline, ftcount + 1)
                        else
                            @info("FAIL: this would start a foot with a short at $(currline) ")
                        end
                   
                    end
                end
            end
        end

        @debug("Returning", currsolutions |> unique)
        currsolutions |> unique
    end
end
