pkgname <- "BSgenome.Crobusta.HT.KY"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('BSgenome.Crobusta.HT.KY')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("package")
### * package

flush(stderr()); flush(stdout())

### Name: BSgenome.Crobusta.HT.KY
### Title: Ciona robusta HT_KY
### Aliases: BSgenome.Crobusta.HT.KY-package BSgenome.Crobusta.HT.KY
###   Crobusta
### Keywords: package data

### ** Examples

BSgenome.Crobusta.HT.KY
bsg <- BSgenome.Crobusta.HT.KY
head(seqlengths(bsg))
seqinfo(bsg)



## ---------------------------------------------------------------------
## Genome-wide motif searching
## ---------------------------------------------------------------------

## See the GenomeSearching vignette in the BSgenome software
## package for some examples of genome-wide motif searching using
## Biostrings and the BSgenome data packages:
if (interactive())
    vignette("GenomeSearching", package="BSgenome")



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
