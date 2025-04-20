{
  description = "Flake to build + develop BSgenome.Crobusta.HT.KY R package";

  nixConfig = {
    bash-prompt = "\[BSgenome.Crobusta.HT.KY$(__git_ps1 \" (%s)\")\]$ ";
  };

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs  = import nixpkgs { inherit system; config.allowUnfree = true; };
        rpkgs = pkgs.rPackages;

		genome = "HT.Ref.fasta";
		bsgenome = "BSgenome.Crobusta.HT.KY";
		fasta = pkgs.fetchurl {
			url  = "http://ghost.zool.kyoto-u.ac.jp/datas/${genome}.zip";
			#hash = "sha256-0s61chcbizajx1ysv35bvl2hmig4kfdy42vrdnpmba379gv5q600=";
			hash = "sha256-pRVAVJxrIk0qH+uN7hakQ5sIk6ruj4nnnLYHKHFEoRo=";
		};

        myPkg = rpkgs.buildRPackage rec {
          name    = "BSgenome.Crobusta.HT.KY";
          pname    = "BSgenome.Crobusta.HT.KY";
          version = "0.2";
          src     = ./.;

          # R‐side dependencies:
          propagatedBuildInputs = [
            rpkgs.BSgenome
          ];

          nativeBuildInputs = [
            pkgs.R
            rpkgs.BSgenomeForge
		  	rpkgs.devtools
			rpkgs.optparse

            pkgs.pkg-config
			pkgs.texlive.combined.scheme-small
			pkgs.texlivePackages.inconsolata
          ];

          # C‑library dependencies
          buildInputs = [
			pkgs.bzip2
			pkgs.curl
			pkgs.gsl
			pkgs.icu75
			pkgs.libpng
			pkgs.libxml2
			pkgs.unzip
          ];

		  #preBuild = ''
		  #  mkdir -p ht_ky
		  #  #make bsgenome.crobusta.ht.ky
		  #  #mv build $out
		  #  cp ${fasta} ${genome}.zip
		  #  unzip -o ${genome}.zip
		  #  #Rscript forgeGenome.R --fasta ${genome} --dir HT_KY
		  #  ls
		  #'';

		  buildPhase = ''
		    mkdir -p HT_KY
		    #make BSgenome.Crobusta.HT.KY
		    #mv build $out
		    cp ${fasta} ${genome}.zip
		    unzip -o ${genome}.zip
		    Rscript forgeGenome.R --fasta ${genome} --dir HT_KY
		    ls
		    R CMD build ${bsgenome}
		  '';

          installPhase = ''
			mkdir -p "$out"
		    #R CMD check ${bsgenome}
            R CMD INSTALL --library=$out ${bsgenome}_${version}.tar.gz
          '';

          # enable Nix’s R-wrapper so it injects R_LD_LIBRARY_PATH
          dontUseSetLibPath = false;

          meta = with pkgs.lib; {
            description = "…";
            license     = licenses.mit;
            maintainers = [ maintainers.kewiechecki ];
          };
        };

		myR = pkgs.rWrapper.override {
# pull in the Bioconductor and CRAN packages you need…
			packages = with rpkgs; [
				BSgenome        # this is 1.74.0 from Nixpkgs
			]
# …and also inject your own package derivation:
			++ [ myPkg ];
		};

      in rec {
        # 1) allow `nix build` with no extra attr:
        defaultPackage = myPkg;

        # 2) drop you into a shell for interactive R work:
        devShells = {
          default = pkgs.mkShell {
            name = "BSgenome.Crobusta.HT.KY-shell";
			#packages = [ myR pkgs.git ];
            buildInputs = [
              pkgs.git
			  myR
              #pkgs.R
              #rpkgs.BSgenome
			  #pkgs.bzip2
			  #pkgs.curl
              #pkgs.gsl
			  #pkgs.icu75
			  #pkgs.libpng
			  #pkgs.libxml2
			  myPkg
            ];
            shellHook = ''
source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh

cat > ./.Rprofile << 'EOF'
.libPaths(c(
  "${myPkg}",
  "${rpkgs.BSgenome}/lib/R/library"
#  .libPaths()
))
EOF

export LD_LIBRARY_PATH="${pkgs.libpng.out}/lib:${pkgs.icu75.out}/lib:${pkgs.bzip2.out}/lib:${pkgs.curl.out}/lib:${pkgs.libxml2.out}/lib:${pkgs.gsl.out}/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="${pkgs.libpng.out}/lib:${pkgs.icu75.out}/lib:${pkgs.bzip2.out}/lib:${pkgs.curl.out}/lib/pkgconfig:${pkgs.libxml2.out}/lib/pkgconfig:${pkgs.gsl.out}/lib/pkgconfig:$PKG_CONFIG_PATH"

#export R_LIBS_USER=""
export R_LIBS_SITE="${myPkg}:${rpkgs.BSgenome}/lib/R/library:$R_LIBS_SITE"
R -e "library(BSgenome.Crobusta.HT.KY); Crobusta; sessionInfo()"
            '';
          };
        };
      });
}

