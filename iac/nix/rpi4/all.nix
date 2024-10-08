# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;
    boot.initrd.systemd.enableTpm2 = false;

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
}
