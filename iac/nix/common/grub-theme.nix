# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    nixpkgs.config.packageOverrides = pkgs: rec {
        mortis-grub = pkgs.callPackage ./mortis-grub.nix {};
        mortis-plymouth = pkgs.callPackage ./mortis-plymouth.nix {};
    };

    boot = {
        plymouth = {
            enable = true;
            theme = "mortis";
            themePackages = with pkgs; [ mortis-plymouth ];
        };

        # Enable "Silent Boot"
        consoleLogLevel = 0;
        initrd.verbose = false;
        initrd.systemd.enable = true;
        kernelParams = [
            "quiet"
            "splash"
            "loglevel=3"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "udev.log_priority=3"
        ];
        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        loader.timeout = 0;

        loader.grub.theme = pkgs.mortis-grub;
    };

    systemd.watchdog.rebootTime = "0";
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "ter-v32n";
        keyMap = "us";
        packages = with pkgs; [ terminus_font ];
    };
}
