{ config, lib, pkgs, ... }:

with pkgs;

let
    delugeTheme = ../../deluge;
    mortisDeluge = pkgs.symlinkJoin {
        name = "mortis-deluge";
        paths = [ pkgs.deluge delugeTheme ];
        version = "2.1.1-1";
        postBuild = ''
            themesDir=$out/lib/python3.12/site-packages/deluge/ui/web/themes/css
            cp $themesDir/xtheme-dark.css $themesDir/xtheme-gray.css
        '';
    };
in {
    services.deluge.package = mortisDeluge;
}
