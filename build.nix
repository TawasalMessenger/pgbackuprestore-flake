{ pkgs, src }:
let
  self = with pkgs; stdenv.mkDerivation {
    name = "pgbackrest";

    inherit src;

    phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" "fixupPhase" ];
    nativeBuildInputs = [ makeWrapper pkg-config openssl libxml2 bzip2 ];
    buildInputs = [ perl perlPackages.DBDPg postgresql ];

    preConfigure = ''
      cd src
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp pgbackrest $out/bin
      chmod 755 $out/bin/pgbackrest
    '';

    fixupPhase = ''
      wrapProgram $out/bin/pgbackrest \
        --prefix PATH : ${stdenv.lib.makeBinPath [ perl perlPackages.DBDPg ]} \
        --set PERL5LIB "$out/${perlPackages.perl.libPrefix}:${with perlPackages; makePerlPath [ DBDPg DBI ]}"
    '';
    #passthru.bin = pgbr + "/bin/pgbackrest";
  };
in
self
