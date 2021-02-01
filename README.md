# pgbackuprestore-flake
Nixos module for [pgBackupRestore](https://github.com/pgbackrest/pgbackrest).

Usage:
    pgbackrest [options] [command]

# Install

## Global installation for NixOS

/etc/nixos/configuration.nix:

```nix
{
# ...
  imports = [
    (import (fetchTarball {
      url = "https://github.com/TawasalMessenger/pgbackuprestore-flake/archive/2.22.tar.gz";
      sha256 = "05891pcyxk233w4dvczjjf0aypmxnkv8w7vi8gjdjlwcgzcs8ym4";
    })).nixosModule
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes;
    '';
  };

  environment.systemPackages = with pkgs; [
      ...
      pgbr
    ];

```

