{ config, lib, pkgs, ... }:

with pkgs;

let
  delugeTheme = ../../deluge;
  mortisDeluge = pkgs.symlinkJoin {
    name = "mortis-deluge";
    paths = [ pkgs.deluge delugeTheme ];
    version = "2.1.1-1";
  };
in {
  services.deluge.package = mortisDeluge;
}
