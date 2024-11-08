locals {
    egress_ip = "149.56.241.127"
}

module "egress_build" {
    source = "github.com/nix-community/nixos-anywhere//terraform/nix-build"
    attribute = "config.system.build.toplevel"
    file = "./nix/egress"
}

module "egress_deploy" {
  source = "github.com/nix-community/nixos-anywhere//terraform/nixos-rebuild"
  nixos_system = module.egress_build.result.out
  target_host = local.egress_ip
  target_user = "build"
  ssh_private_key = file("${path.cwd}/builder-key")
}
