
"""Alternate approach to parsing metrical structure following algorithm described by Papachitzos.
$(SIGNATURES)
"""
function hexameter(s; ortho = literaryGreek())
    syllables = syllabify(s,ortho)
    #@info(length(syllables))
    length(syllables)
end