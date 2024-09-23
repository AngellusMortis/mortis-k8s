locals {
    pi_1_ip = "192.168.1.10"
    pi_2_ip = "192.168.1.12"
}

module "pi_1_build" {
    source = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
    attribute = "config.system.build.toplevel"
    file = "./nix/pi-1"
    nix_options = {
        builders = "@${path.cwd}/nix/machines"
    }
}

module "pi_1_deploy" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nixos-rebuild"
  nixos_system = module.pi_1_build.result.out
  target_host = local.pi_1_ip
  target_user = "build"
  ssh_private_key = file("${path.cwd}/builder-key")
}


module "pi_2_build" {
    source = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
    attribute = "config.system.build.toplevel"
    file = "./nix/pi-2"
    nix_options = {
        builders = "@${path.cwd}/nix/machines"
    }
}

module "pi_2_deploy" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nixos-rebuild"
  nixos_system = module.pi_2_build.result.out
  target_host = local.pi_2_ip
  target_user = "build"
  ssh_private_key = file("${path.cwd}/builder-key")
}
