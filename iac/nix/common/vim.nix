{ pkgs, ... }:
{
  programs.vim.defaultEditor = true;

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { python = python3; }).customize {
      name = "vim";
    })
  ];
}
