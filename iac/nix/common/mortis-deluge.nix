{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
    pname = "mortis-deluge";
    version = "0.1.0";

    src = ../../deluge;

    configurePhase = ''
    mkdir -p $out/
    '';

    installPhase = ''
    cp -r * $out/
    '';
}
