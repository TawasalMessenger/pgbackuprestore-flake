{ pkgs, src }:
let
  self = with pkgs; stdenv.mkDerivation {
    name = "pgbackrest";

    inherit src;

    phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" "fixupPhase" ];
    nativeBuildInputs = [ makeWrapper pkg-config ];
    buildInputs = [ perl perlPackages.DBDPg postgresql openssl libxml2 bzip2 libyaml ];

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
        --prefix PATH : ${lib.makeBinPath [ perl perlPackages.DBDPg ]} \
        --set PERL5LIB "$out/${perlPackages.perl.libPrefix}:${with perlPackages; makePerlPath [ DBDPg DBI ]}"
    '';
    #passthru.bin = pgbr + "/bin/pgbackrest";
  };
in
self
