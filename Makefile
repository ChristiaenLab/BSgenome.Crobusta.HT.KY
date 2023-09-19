FASTA = HT.Ref.fasta
URL = http://ghost.zool.kyoto-u.ac.jp/datas/$(FASTA).zip
GENOME = Crobusta.HT.KY
RELEASE = HT_KY

install: BSgenome.$(GENOME).tar.gz
	R CMD check BSgenome.$(GENOME)
	R CMD INSTALL BSgenome.$(GENOME)

BSgenome.$(GENOME).tar.gz: BSgenome.$(GENOME)
	R CMD build BSgenome.$(GENOME)

BSgenome.$(GENOME): $(FASTA)
	Rscript forgeGenome.R --fasta $(FASTA) --dir $(RELEASE)

$(FASTA): $(FASTA).zip
	unzip -o $(FASTA).zip

$(FASTA).zip: $(RELEASE)
	curl $(URL) > HT.Ref.fasta.zip

$(RELEASE):
	mkdir $(RELEASE)

clean:
	rm -rf $(RELEASE)
	rm -f $(FASTA)
	rm -f $(FASTA).zip
	rm -rf BSgenome.$(GENOME)
