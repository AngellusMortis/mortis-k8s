{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
    pname = "mortis-grub";
    version = "0.1.0";

    src = ../../grub;

    configurePhase = ''
    mkdir -p $out/
    '';

    installPhase = ''
    cp -r theme/* $out/
    '';
}
