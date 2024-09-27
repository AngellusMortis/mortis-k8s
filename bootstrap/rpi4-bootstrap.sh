#!/bin/bash

echo "Generating inital config..."
nixos-generate-config

echo "Adding nixos-hardware..."
nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
nix-channel --update

echo "Updating eeprom..."
nix-shell -p raspberrypi-eeprom --run "rpi-eeprom-update -d -a"

echo "Adding base rpi4.nix..."
curl -sL http://files.wl.mort.is/rpi4.nix -o /etc/nixos/rpi4.nix
sed -i -z 's|./hardware-configuration.nix\n|./hardware-configuration.nix\n      ./rpi4.nix\n|' /etc/nixos/configuration.nix

echo "Rebuilding config..."
nixos-rebuild switch
