let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz";
in
import (nixpkgs + "/nixos/lib/eval-config.nix") {
  modules = [ ./configuration.nix ];
}
