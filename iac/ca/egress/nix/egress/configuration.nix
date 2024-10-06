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
        # ../../../../nix/common/sops.nix
    ];

    # console.enable = true;

    # sops.secrets.cf_tunnel = {
    #     owner = "cloudflared";
    #     group = "cloudflared";
    #     # The sops file can be also overwritten per secret...
    #     sopsFile = ../../secrets/cf-tunnel.json;
    #     # ... as well as the format
    #     format = "binary";
    # };

    # sops.secrets.wg_private_key = {
    #     # restartUnits = [ "home-assistant.service" ];
    #     sopsFile = ../../secrets/wg.yml;
    #     format = "yaml";
    # };
    # sops.secrets.wg_public_key = {
    #     # restartUnits = [ "home-assistant.service" ];
    #     sopsFile = ../../secrets/wg.yml;
    #     format = "yaml";
    # };
    # sops.secrets.wg_endpoint = {
    #     # restartUnits = [ "home-assistant.service" ];
    #     sopsFile = ../../secrets/wg.yml;
    #     format = "yaml";
    # };
    # sops.templates."wg0.conf" = {
    #     content = ''
    #     [Interface]
    #     PrivateKey = ${config.sops.placeholder.wg_private_key}
    #     Address = 10.8.0.112/32
    #     DNS = 1.1.1.1
    #     ListenPort = 51820
    #     Table = off

    #     [Peer]
    #     PublicKey = ${config.sops.placeholder.wg_public_key}
    #     AllowedIPs = 0.0.0.0/1, 128.0.0.0/2, 192.0.0.0/9, 192.128.0.0/11, 192.160.0.0/13, 192.169.0.0/16, 192.170.0.0/15, 192.172.0.0/14, 192.176.0.0/12, 192.192.0.0/10, 193.0.0.0/8, 194.0.0.0/7, 196.0.0.0/6, 200.0.0.0/5, 208.0.0.0/4, 224.0.0.0/3
    #     Endpoint = ${config.sops.placeholder.wg_endpoint}
    #     '';
    #     path = "/etc/wireguard/wg0.conf";
    # };

    networking.hostName = "egress";

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        mirroredBoots = [
            {
                devices = [ "/dev/disk/by-uuid/1190-836B" ];
                path = "/boot2";
                efiSysMountPoint = "/boot2/efi";
            }
        ];
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.swraid.enable = true;

    networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
    networking.firewall = {
        allowedTCPPorts = [ 22 51820 ];
        allowedUDPPorts = [ 51820 ];
        # checkReversePath = "loose";

        # extraCommands = ''
        #     iptables -t nat -A PREROUTING -p tcp --dport 8112 -j DNAT --to-destination 10.8.0.112:8112
        #     iptables -t nat -A POSTROUTING -p tcp -d 10.8.0.112 --dport 8112 -j SNAT --to-source 10.8.0.112

        #     iptables -t nat -A PREROUTING -p tcp --dport 58846 -j DNAT --to-destination 10.8.0.112:58846
        #     iptables -t nat -A POSTROUTING -p tcp -d 10.8.0.112 --dport 58846 -j SNAT --to-source 10.8.0.112
        # '';
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        wireguard-tools
    ];

    services = {
        # cloudflared = {
        #     enable = true;
        #     tunnels = {
        #         "4ce0b609-4efd-40a2-8421-7256ba534d21" = {
        #             credentialsFile = config.sops.secrets.cf_tunnel.path;
        #             default = "http_status:404";
        #             originRequest.noTLSVerify = true;
        #             ingress = {
        #                 "download.dc.mort.is" = "http://localhost:8112";
        #                 "plex.dc.mort.is" = "https://localhost:32400";
        #                 "ssh.dc.mort.is" = "ssh://localhost:22";
        #                 "sync.dc.mort.is" = "http://localhost:8384";
        #             };
        #         };
        #     };
        # };

        fail2ban = {
            enable = true;
            # Ban IP after 5 failures
            maxretry = 5;
            bantime = "24h"; # Ban IPs for one day on the first ban
            bantime-increment = {
                enable = true; # Enable increment of bantime after each violation
                formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
                maxtime = "168h"; # Do not ban for more than 1 week
                overalljails = true; # Calculate the bantime based on all the violations
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
