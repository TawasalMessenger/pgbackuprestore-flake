{
  description = "Postgres backup/restore";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-20.09";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    src = {
      url = "https://github.com/pgbackrest/pgbackrest/archive/release/2.22.tar.gz";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat, src }:
    let
      sources = with builtins; (fromJSON (readFile ./flake.lock)).nodes;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pgbr = import ./build.nix {
        inherit pkgs src;
      };
      mkApp = drv: {
        type = "app";
        program = "${drv.pname or drv.name}${drv.passthru.exePath}";
      };
      derivation = { inherit pgbr; };
    in
    with pkgs; rec {
      packages.${system} = derivation;
      defaultPackage.${system} = pgbr;
      apps.${system}.pgbr = mkApp { drv = pgbr; };
      defaultApp.${system} = apps.pgbr;
      legacyPackages.${system} = extend overlay;
      devShell.${system} = callPackage ./shell.nix derivation;
      nixosModule.nixpkgs.overlays = [ overlay ];
      overlay = final: prev: derivation;
    };
}
