library(BSgenomeForge)
library(optparse)
library(rtracklayer)

parser <- OptionParser()
parser <- add_option(parser,'--fasta',action='store',default="HT.Ref.fasta")
parser <- add_option(parser,'--dir',action='store',default="HT_KY")
opts <- parse_args(parser)

ky <- readDNAStringSet(opts$fasta)
export.2bit(ky,"HT_KY/HT.Ref.2bit")
forgeBSgenomeDataPkg("DESCRIPTION", 
					 #seqs_srcdir = ".",
					 #destdir = opts$dir,
					 replace = T, verbose = T)
