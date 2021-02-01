{pkgs, src}:
let
  self = pkgs.stdenv.mkDerivation {
  name = "pgbackrest";

  inherit src;

  phases = [ "unpackPhase" "configurePhase" "buildPhase" "installPhase" "fixupPhase" ];
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [ perl perlPackages.DBDPg openssl libxml2 postgresql ];

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
      --prefix PATH : ${
      pkgs.stdenv.lib.makeBinPath [
        pkgs.perl
        pkgs.perlPackages.DBDPg
      ]
    } \
    --set PERL5LIB "$out/${pkgs.perlPackages.perl.libPrefix}:${with pkgs.perlPackages; makePerlPath [ DBDPg DBI ] }"
  '';
  #passthru.bin = pgbr + "/bin/pgbackrest";
};
in
self
