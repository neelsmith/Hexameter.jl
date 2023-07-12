
"""Parse meter of a single hexameter.
$(SIGNATURES)
"""
function stichos(s; ortho = literaryGreek())
    @info("HEY: PARSE $(s)")
    syllables = syllabify(s,ortho)
    lastfoot = syllables[end-1:end]
    scores = scoresyllables(syllables[1:end-2], ortho = ortho)
    popfoot(scores, syllables) .* string("|", join(lastfoot, "-"))
end

"""Recusively pop one metrical foot of syllables from two parallel 
vectors of equal length: `textv`, the vector of syllables for a hexameter, and `quantsv`, the vector of scores for each syllable.
$(SIGNATURES)

Returns a string formatted in convention of pipe character separating feet,
hyphens separating syllables.
"""
function popfoot(quantsv, textv, solutions = [], inprogress = "", ftcount = 1)
    # Return value for final set of solutions:
    currsolutions = solutions
    currline = inprogress

    @info("From ", join(textv,","), currline, currsolutions)
    @info("Size of quantsv ", length(quantsv))
    if isempty(quantsv)
        @info("FINISHED: look at ", currline, textv[1])
        if length(split(currline), "|") == 6 && (! shortvowel(textv[1]))
            @info("SYLL 1", text[1])
            @info("SUCCESS", solutions)
            push!(currsolutions, currline)
        else
            @info("Wrong number of feet in $(currline)")
        end
    

    elseif length(quantsv) == 1
        @debug("FAILED ", textv, currline)
        []

    else # more to analyze
        @debug("Len quantsv", length(quantsv))
        for (i,j) in Iterators.product([2], quantsv[2])
               if i + j == 4
                tval = join([inprogress, join(textv[1:2],"-")], "|")
                @debug(tval)
                currline = tval
                @debug("Recurse with", currline, currsolutions)
               if length(quantsv)== 2
                    push!(currsolutions, currline)
               else
                    popfoot(quantsv[3:end], textv[3:end], currsolutions, currline, ftcount + 1)
               end
            end
        end
        if length(quantsv) > 2
            for (i,j,k) in Iterators.product([2], quantsv[2], quantsv[3])
                if sum([i,j,k]) == 4
                    currline = join([inprogress, join(textv[1:3],"-")], "|")
                    @debug("Recurse with", inprogress, solutions)
                    if length(quantsv) == 3
                        push!(currsolutions, currline)
                    else
                        popfoot(quantsv[4:end], textv[4:end], currsolutions, currline, ftcount + 1)
                    end
                end
            end
        end
        @debug("Returning", currsolutions |> unique)
        currsolutions |> unique
    end
end
