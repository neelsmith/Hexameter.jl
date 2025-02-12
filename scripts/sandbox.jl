using CitableBase, CitableCorpus
using Hexameter
using Orthography, PolytonicGreek

f = joinpath(pwd(), "test", "assets", "iliad-allen.cex")

corp = fromcex(f, CitableTextCorpus, FileReader)


