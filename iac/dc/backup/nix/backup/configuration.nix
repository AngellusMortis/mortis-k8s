# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../../../nix/common/mdcheck.nix
        ../../../../nix/common/all.nix
        ../../../../nix/common/grub-theme.nix
        ../../../../nix/common/sops.nix
        ../../../../nix/common/mortis-deluge.nix
    ];

    sops.secrets.cf_tunnel = {
        owner = "cloudflared";
        group = "cloudflared";
        # The sops file can be also overwritten per secret...
        sopsFile = ../../secrets/cf-tunnel.json;
        # ... as well as the format
        format = "binary";
    };

    nixpkgs.config.allowUnfree = true;

    networking.hostName = "backup-1";
    networking.hostId = "33ad4037";

    boot.loader.systemd-boot.enable = false;
    boot.supportedFilesystems.zfs = true;
    boot.zfs = {
        forceImportRoot = false;
        allowHibernation = true;
        extraPools = [ "zpool" ];
    };
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        mirroredBoots = [
            {
                devices = [ "/dev/disk/by-uuid/CE53-9E71" ];
                path = "/boot2";
                efiSysMountPoint = "/boot2/efi";
            }
        ];
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.swraid.enable = true;
    boot.initrd = {
        luks.devices."OS" = {
            device = "/dev/md/nixos:os";
            preLVM = true;
            keyFile = "/etc/secrets/initrd/keyfile0.bin";
            allowDiscards = true;
        };
        secrets = {
            "/etc/secrets/initrd/keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
        };
    };

    networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
    networking.firewall.allowedTCPPorts = [ 22 8112 8384 9100 9134 11024 22000 32400 ];
    networking.firewall.allowedUDPPorts = [ 11024 22000 ];

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
    systemd.services.zfs-import-zpool.after = ["-.mount" "nix-store.mount" ];
    systemd.services.zfs-import-zpool.wants = [ "-.mount" "nix-store.mount" ];

    services = {
        cloudflared = {
            enable = true;
            tunnels = {
                "4ce0b609-4efd-40a2-8421-7256ba534d21" = {
                    credentialsFile = config.sops.secrets.cf_tunnel.path;
                    default = "http_status:404";
                    originRequest.noTLSVerify = true;
                    ingress = {
                        "download.dc.mort.is" = "http://localhost:8112";
                        "plex.dc.mort.is" = "https://localhost:32400";
                        "ssh.dc.mort.is" = "ssh://localhost:22";
                        "sync.dc.mort.is" = "http://localhost:8384";
                    };
                };
            };
        };

        deluge = {
            enable = true;
            web.enable = true;
        };

        plex.enable = true;

        syncthing = {
            enable = true;
            guiAddress = "0.0.0.0:8384";
            overrideDevices = true;     # overrides any devices added or deleted through the WebUI
            overrideFolders = true;     # overrides any folders added or deleted through the WebUI
            settings = {
                options = {
                    insecureAdminAccess = true;
                    urAccepted = -1;
                };
                devices = {
                    "sync.wl.mort.is" = {
                        id = "PQ576SA-HA27WE6-Q6HTLHE-5WQD77V-WY7CJV7-PVI3HXA-CYVB2LF-GJJQMAS";
                        addresses = [
                            "quic://192.168.3.236:22000"
                            "tcp://192.168.3.236:22000"
                        ];
                    };
                };
                folders = {
                    "backup" = {
                        id = "my6er-4vegd";
                        label = "Backup";
                        path = "/opt/backup";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 2592000; # once a month
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "download-internal" = {
                        id = "azqqf-spmzm";
                        label = "Download - Internal Complete";
                        path = "/opt/download/in/complete";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendonly";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = null;
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "download-complete" = {
                        id = "zn4ex-cjsuj";
                        label = "Download - Complete";
                        path = "/opt/download/p/complete";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendonly";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = null;
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "media-games" = {
                        id = "wadfp-trxlq";
                        label = "Media - Games";
                        path = "/opt/media/games";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 604800; # once a week
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "media-movies" = {
                        id = "kdjcn-4czrm";
                        label = "Media - Movies";
                        path = "/opt/media/movies";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        ignoreDelete = true;
                        fsWatcherEnabled = true;
                        rescanIntervalS = 2592000; # once a month
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "media-music" = {
                        id = "yw2q2-vw3jc";
                        label = "Media - Music";
                        path = "/opt/media/music";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "media-sounds" = {
                        id = "fpe6i-t4azv";
                        label = "Media - Sounds";
                        path = "/opt/media/sounds";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                    };
                    "media-television" = {
                        id = "avkrt-rsvhx";
                        label = "Media - Television";
                        path = "/opt/media/television";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        ignoreDelete = true;
                        fsWatcherEnabled = true;
                        rescanIntervalS = 2592000; # once a month
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "public" = {
                        id = "tg4pk-fhmzv";
                        label = "Public";
                        path = "/opt/public";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "personal-cbailey" = {
                        id = "2mh7q-umkep";
                        label = "Personal Data - cbailey";
                        path = "/opt/syncthing/personal/cbailey";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "personal-sbailey" = {
                        id = "feiyy-sjasb";
                        label = "Personal Data - sbailey";
                        path = "/opt/syncthing/personal/sbailey";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                    "shared" = {
                        id = "prdrk-2gtju";
                        label = "Shared Data";
                        path = "/opt/syncthing/shared";
                        devices = [ "sync.wl.mort.is" ];
                        type = "sendreceive";
                        fsWatcherEnabled = true;
                        rescanIntervalS = 3600; # once a hour
                        versioning = {
                            type = "trashcan";
                            params.cleanoutDays = "30";
                        };
                        ignorePatterns = [
                            "lost+found"
                            "**:**"
                        ];
                    };
                };
            };
        };
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
