# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;

    hardware = {
        raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        deviceTree = {
        enable = true;
            filter = "*rpi-4-*.dtb";
        };
    };

    networking.domain = "wl.mort.is";
    # networking.hostName = "pi-2"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    networking.enableIPv6 = false;

    # Set your time zone.
    time.timeZone = "America/New_York";

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console.enable = false;
    # console = {
    #   font = "Lat2-Terminus16";
    #   keyMap = "us";
    #   useXkbConfig = true; # use xkb.options in tty.
    # };

    # Enable the X11 windowing system.
    # services.xserver.enable = true;

    # Configure keymap in X11
    # services.xserver.xkb.layout = "us";
    # services.xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # services.printing.enable = true;

    # Enable sound.
    # hardware.pulseaudio.enable = true;
    # OR
    # services.pipewire = {
    #   enable = true;
    #   pulse.enable = true;
    # };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.root.hashedPassword = "!";
    users.users.build = {
        isNormalUser = true;
        home = "/home/build";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwDKM5fakow2MdR6YJ2qxX0TvAvqGbi9Dzugf04PM7z cbailey@angellus-pc"
        ];
    };
    nix.settings.trusted-users = [ "root" "build" ];

    users.users.cbailey = {
        isNormalUser = true;
        home = "/home/cbailey";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2/jfutcgquJZEp2Y8OLflLREcNB7+j8ugsc9QiyhTS yubikey-125"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICaX+NiipC9sPhj9wyvpBTwatHmO8avPLEWdTVT/b+zR yubikey-224"
        ];
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

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim
        btop
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    networking.firewall.enable = true;
}
