{ stdenv, ghc, ghcWrapper, makeWrapper, coreutils }:

stdenv.mkDerivation ({
  name = "ghc-${ghc.version}-outer-wrapper";
#  inherit (ghcWrapper) src;

  buildInputs = [makeWrapper];                                                   
  propagatedBuildInputs = [ghc];                                                 

  unpackPhase = "true";                                                          

  installPhase = ghcWrapper.installPhase;

  postFixup= ''                                                                  
    # link ghcWrapper ./bin to bin
    ln -s $gch/bin $out/bin
    # make sure doc file exists, only needed when this is the first package      
    # insstalled that needs a doc folder.                                        
    mkdir -p $out/share/doc                                                      
    ln -s $ghc/lib $out/lib
                                                                                 
    # copy ./doc/ghc to ./doc/ghc-${ghc.version} to prevent name conflicts       
    ln -s $ghc/share/doc/ghc $out/share/doc/ghc-${ghc.version}
  '';

  GHCGetPackages = ./ghc-get-packages.sh;                                        
                                                                                 
  inherit ghc;                                                                   
  inherit (ghc) meta;                                                            
  ghcVersion = ghc.version; 

}) 
