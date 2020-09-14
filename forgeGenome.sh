wget -U firefox http://ghost.zool.kyoto-u.ac.jp/datas/HT.Ref.fasta.zip
unzip -o HT.Ref.fasta.zip
rm HT.Ref.fasta.zip
mkdir -p HT.KY
Rscript forgeGenome.R
rm HT.Ref.fasta
R CMD build BSgenome.Crobusta.HT.KY
R CMD check BSgenome.Crobusta.HT.KY
R CMD INSTALL BSgenome.Crobusta.HT.KY
rm -r HT.KY
