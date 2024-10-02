{
  imports = let
    # replace this with an actual commit id or tag
    commit = "3198a242e547939c5e659353551b0668ec150268";
  in [
    "${builtins.fetchTarball {
      url = "https://github.com/Mic92/sops-nix/archive/master.tar.gz";
    }}/modules/sops"
  ];
}
