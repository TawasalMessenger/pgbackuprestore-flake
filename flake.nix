{
  description = "Postgres backup/restore";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    src = {
      url = "https://github.com/pgbackrest/pgbackrest/archive/release/2.32.tar.gz";
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
      derivation = { inherit pgbr; };
    in
    with pkgs; rec {
      packages.${system} = derivation;
      defaultPackage.${system} = pgbr;
      legacyPackages.${system} = extend overlay;
      devShell.${system} = pkgs.mkShell {
        name = "pgbr-env";
        buildInputs = [ pgbr ];
      };
      nixosModule.nixpkgs.overlays = [ overlay ];
      overlay = final: prev: derivation;
    };
}
