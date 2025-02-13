using CitableBase, CitableCorpus
using Hexameter
using Orthography, PolytonicGreek

f = joinpath(pwd(), "test", "assets", "iliad-allen.cex")

corp = fromcex(f, CitableTextCorpus, FileReader)

textlines = map(psg -> psg.text, corp.passages)

@time syllcounts = map(ln -> hexameter(ln), textlines)

using StatsBase, OrderedCollections
countfreqs = countmap(syllcounts) |> OrderedDict

sort!(countfreqs; rev=true, byvalue=true)


@time seventeens = filter(l -> hexameter(l) == 17, textlines)
seventeens