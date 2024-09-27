# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../../../nix/common/mdcheck.nix
        ../../../../nix/common/all.nix
    ];

    networking.hostName = "backup-1";
    networking.hostId = "33ad4037";

    boot.loader.systemd-boot.enable = false;
    boot.supportedFilesystems.zfs = true;
    boot.zfs = {
        forceImportRoot = false;
        allowHibernation = true;
    };
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        zfsSupport = true;
        mirroredBoots = [
            {
                devices = [ "/dev/disk/by-uuid/CE53-9E71" ];
                path = "/boot2/efi";
            }
        ];
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.swraid.enable = true;
    boot.initrd = {
        supportedFilesystems = ["zfs"];
        luks.devices."OS" = {
            device = "/dev/md/nixos:os";
            preLVM = true;
            keyFile = "/keyfile0.bin";
            allowDiscards = true;
        };
        secrets = {
            # Create /mnt/etc/secrets/initrd directory and copy keys to it
            "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
        };
    };

    networking.firewall.allowedTCPPorts = [ 22 9100 9134 ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        zfs
    ];

    services.prometheus.exporters.node.enable = true;
    services.prometheus.exporters.zfs.enable = true;
    services.zfs = {
        autoScrub.enable = true;
        autoSnapshot.enable = true;
        trim.enable = true;
    };

    # Copy the NixOS configuration file and link it from the resulting system
    # (/run/current-system/configuration.nix). This is useful in case you
    # accidentally delete configuration.nix.
    # system.copySystemConfiguration = true;

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "24.05"; # Did you read the comment?
}
