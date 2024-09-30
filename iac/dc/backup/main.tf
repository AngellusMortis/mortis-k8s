locals {
    build_ip = "192.168.3.15"
}

module "backup_build" {
    source = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
    attribute = "config.system.build.toplevel"
    file = "./nix/backup"
}

module "backup_deploy" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nixos-rebuild"
  nixos_system = module.backup_build.result.out
  target_host = local.build_ip
  target_user = "build"
  ssh_private_key = file("${path.cwd}/builder-key")
}
