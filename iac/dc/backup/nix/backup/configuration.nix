# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        # ../../../../nix/common/all.nix
    ];

    networking.hostName = "backup-1";

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        # devices = [
        #   "/dev/disk/by-partuuid/d3a5027a-f331-487f-a5f2-5800f5596e97"
        #   "/dev/disk/by-partuuid/57e7ccfc-5fc1-4748-8cee-165d8b054b86"
        # ];
        efiSupport = true;
        enableCryptodisk = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.swraid.enable = true;
    boot.initrd = {
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

    nix.settings.trusted-users = [ "root" "build" ];
    users.users.root.hashedPassword = "!";
    users.users.build = {
        isNormalUser = true;
        home = "/home/build";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwDKM5fakow2MdR6YJ2qxX0TvAvqGbi9Dzugf04PM7z cbailey@angellus-pc"
        ];
    };
    users.users.cbailey = {
        isNormalUser = true;
        uid = 1000;
        home = "/home/cbailey";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2/jfutcgquJZEp2Y8OLflLREcNB7+j8ugsc9QiyhTS yubikey-125" ];
    };
    security.sudo.extraRules = [
        {
            users = [ "cbailey" "build" ];
            commands = [
                {
                    command = "ALL";
                    options = [ "NOPASSWD" ];
                }
            ];
        }
    ];
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];

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
