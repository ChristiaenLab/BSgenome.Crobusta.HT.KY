library(BSgenome)
library(optparse)

parser <- OptionParser()
parser <- add_option(parser,'--fasta',action='store',default="HT.Ref.fasta")
parser <- add_option(parser,'--dir',action='store',default="HT_KY")
opts <- parse_args(parser)

ky <- readLines(opts$fasta)
file.start <- grep('>',ky)
file.end <- c(file.start[-1]-1,length(ky))
file.names <- paste0(opts$dir,"/",sub('>','',ky[file.start]),'.fa')

# forgeSeqFiles(sub('>','',ky[file.start]), seqfile_name = opts$fasta, seqs_destdir = opts$dir)
mapply(
  function(start,end,name) writeLines(ky[start:end],name),
  file.start,
  file.end,
  file.names
)

forgeBSgenomeDataPkg("DESCRIPTION")
