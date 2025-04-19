###
###

.pkgname <- "BSgenome.Crobusta.HT.KY"

.seqnames <- NULL

.circ_seqs <- character(0)

.mseqnames <- NULL

.onLoad <- function(libname, pkgname)
{
    if (pkgname != .pkgname)
        stop("package name (", pkgname, ") is not ",
             "the expected name (", .pkgname, ")")
    extdata_dirpath <- system.file("extdata", package=pkgname,
                                   lib.loc=libname, mustWork=TRUE)

    ## Make and export BSgenome object.
    bsgenome <- BSgenome(
        organism="Ciona robusta",
        common_name="Vase tunicate",
        genome="HT_KY",
        provider="Ghost",
        release_date="2019",
        source_url="http://ghost.zool.kyoto-u.ac.jp/datas/HT.Ref.fasta.zip",
        seqnames=.seqnames,
        circ_seqs=.circ_seqs,
        mseqnames=.mseqnames,
        seqs_pkgname=pkgname,
        seqs_dirpath=extdata_dirpath
    )

    ns <- asNamespace(pkgname)

    objname <- pkgname
    assign(objname, bsgenome, envir=ns)
    namespaceExport(ns, objname)

    old_objname <- "Crobusta"
    assign(old_objname, bsgenome, envir=ns)
    namespaceExport(ns, old_objname)
}

