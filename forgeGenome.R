library(BSgenome)
ky <- readLines("HT.Ref.fasta")
file.start <- grep('>',ky)
file.end <- c(file.start[-1]-1,length(ky))
file.names <- paste0("HT.KY/",sub('>','',ky[file.start]),'.fa')
mapply(
  function(start,end,name) writeLines(ky[start:end],name),
  file.start,
  file.end,
  file.names
)
forgeBSgenomeDataPkg("DESCRIPTION")
