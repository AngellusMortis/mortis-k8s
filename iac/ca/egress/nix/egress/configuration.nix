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
    ];

    console.enable = true;

    sops.secrets.cf_tunnel = {
        owner = "cloudflared";
        group = "cloudflared";
        restartUnits = [ "cloudflared-tunnel-23ae6268-e1b3-4fa9-aa74-e382a7d9f17d.service" ];
        # The sops file can be also overwritten per secret...
        sopsFile = ../../secrets/cf-tunnel.json;
        # ... as well as the format
        format = "json";
    };

    sops.secrets.wg_private_key = {
        restartUnits = [ "wireguard-wg0.service" ];
        sopsFile = ../../secrets/wg.yml;
        format = "yaml";
    };

    networking.hostName = "egress";

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
        mirroredBoots = [
            {
                devices = [ "/dev/disk/by-uuid/DA25-27CD" ];
                path = "/boot2";
                efiSysMountPoint = "/boot2/efi";
            }
        ];
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.swraid.enable = true;

    networking.nat.enable = true;
    networking.nat.externalInterface = "eno1";
    networking.nat.internalInterfaces = [ "wg0" ];

    networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
    networking.firewall = {
        allowedTCPPorts = [ 22 11024 22048 ];
        allowedUDPPorts = [ 11024 22048 51820 ];
    };

    networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
        wg0 = {
            # Determines the IP address and subnet of the server's end of the tunnel interface.
            ips = [ "10.8.0.10/24" ];

            # The port that WireGuard listens to. Must be accessible by the client.
            listenPort = 51820;

            # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
            # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
            postSetup = ''
                ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eno1 -j MASQUERADE
                ${pkgs.iptables}/bin/iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
                ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -o eno1 -j ACCEPT

                # k8s / delugevpn
                ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp -i eno1 --dport 11024 -j DNAT --to-destination 10.8.0.110:11024
                ${pkgs.iptables}/bin/iptables -A FORWARD -p tcp -d 10.8.0.110 --dport 11024 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p udp -i eno1 --dport 11024 -j DNAT --to-destination 10.8.0.110:11024
                ${pkgs.iptables}/bin/iptables -A FORWARD -p udp -d 10.8.0.110 --dport 11024 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

                # dc / deluge
                ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p tcp -i eno1 --dport 22048 -j DNAT --to-destination 10.8.0.112:22048
                ${pkgs.iptables}/bin/iptables -A FORWARD -p tcp -d 10.8.0.112 --dport 22048 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
                ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -p udp -i eno1 --dport 22048 -j DNAT --to-destination 10.8.0.112:22048
                ${pkgs.iptables}/bin/iptables -A FORWARD -p udp -d 10.8.0.112 --dport 22048 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
            '';

            # This undoes the above command
            postShutdown = ''
                ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.8.0.0/24 -o eno1 -j MASQUERADE
            '';

            # Path to the private key file.
            #
            # Note: The private key can also be included inline via the privateKey option,
            # but this makes the private key world-readable; thus, using privateKeyFile is
            # recommended.
            privateKeyFile = config.sops.secrets.wg_private_key.path;

            peers = [
                # List of allowed peers.
                # k8s / delugevpn
                {
                    publicKey = "TArn8JV3Z+yAKMMDaiB4v869Pp+1oSqjyqTEIrnXdSg=";
                    # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
                    allowedIPs = [ "10.8.0.110/32" ];
                }
                # dc / deluge
                {
                    publicKey = "tq79/lA5En/jElIe5ONA1mIGwEYq2z4LZr+Ych2cTmQ=";
                    # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
                    allowedIPs = [ "10.8.0.112/32" ];
                }
            ];
        };
    };

    # disable auto-tmux
    home-manager.users.cbailey.programs.zsh.envExtra = ''
        MORTIS_USE_TMUX=false
    '';

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        wireguard-tools
    ];

    services = {
        cloudflared = {
            enable = true;
            tunnels = {
                "23ae6268-e1b3-4fa9-aa74-e382a7d9f17d" = {
                    credentialsFile = config.sops.secrets.cf_tunnel.path;
                    default = "http_status:404";
                    originRequest.noTLSVerify = true;
                    ingress = {
                        "ca.mort.is" = "ssh://localhost:22";
                    };
                };
            };
        };

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
