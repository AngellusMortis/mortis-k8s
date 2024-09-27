{ config, lib, pkgs, ... }:
{
  imports =
    [
      <nixos-hardware/raspberry-pi/4>
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  nix.settings.trusted-users = [ "root" "build" ];

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
}
