{ pkgs, ... }:
{
    programs.vim.defaultEditor = true;

    environment.systemPackages = with pkgs; [
        (
            (vim_configurable.override { python = python3; }).customize {
                name = "vim";
                vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
                    start = [ vim-nix ]; # load plugins on startup
                };
            }
        )
    ];
}
