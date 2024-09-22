# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    networking.firewall.allowedTCPPorts = [ 3306 ];

    services.mysql = {
        enable = true;
        package = pkgs.mariadb;
        initialDatabases = [
            { name = "blocky"; }
            { name = "grafana"; }
        ];
        ensureDatabases = [
          "blocky"
        ];
        ensureUsers = [
            {
              name = "blocky";
              ensurePermissions = {
                "blocky.*" = "ALL PRIVILEGES";
              };
            }
            {
              name = "grafana";
              ensurePermissions = {
                "blocky.*" = "SELECT";
              };
            }
        ];
    };
}
