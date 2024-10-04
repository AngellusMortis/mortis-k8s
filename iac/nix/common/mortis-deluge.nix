{ config, lib, pkgs, ... }:

with pkgs;

let
    delugeTheme = ../../deluge;
    mortisDeluge = pkgs.symlinkJoin {
        name = "mortis-deluge";
        paths = [ pkgs.deluge delugeTheme ];
        version = "2.1.1-1";
        postBuild = ''
            srcBin=$(readlink $out/bin/deluge-web)
            rm $out/bin/deluge-web
            cp $srcBin $out/bin/deluge-web
        '';
    };
in {
    services.deluge.package = mortisDeluge;
}
