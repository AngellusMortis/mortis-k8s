{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
    pname = "mortis-plymouth";
    version = "0.1.0";

    src = ../../plymouth;

    configurePhase = ''
    mkdir -p $out/share/plymouth/themes/
    '';

    installPhase = ''
    cp -r theme $out/share/plymouth/themes/mortis
    find $out/share/plymouth/themes/ -name \*.plymouth -exec sed -i "s@\/usr\/@$out\/@" {} \;
    '';
}
