# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;
    boot.initrd.systemd.tpm2.enable = false;

    hardware = {
        raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        deviceTree = {
        enable = true;
            filter = "*rpi-4-*.dtb";
        };
    };

    # sdcards are really slow
    home-manager.users.cbailey.programs.zsh.enableCompletion = false;
    home-manager.users.root.programs.zsh.enableCompletion = false;

    # disable auto-tmux
    home-manager.users.cbailey.programs.zsh.envExtra = ''
        MORTIS_USE_TMUX=false
    '';

    nix.settings.substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nixos-raspberrypi.cachix.org"
    ];
    nix.settings.trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
}
