# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports = [
        <home-manager/nixos>
        ./tmux-session.nix
    ];

    boot.loader.grub.configurationLimit = 10;
    nix.gc.automatic = true;

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
    console.enable = lib.mkDefault false;
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

    users.users.root.hashedPassword = "!";
    nix.settings.trusted-users = [ "root" "build" ];

    users.users.build = {
        isNormalUser = true;
        home = "/home/build";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwDKM5fakow2MdR6YJ2qxX0TvAvqGbi9Dzugf04PM7z cbailey@angellus-pc"
        ];
    };
    home-manager.users.build = { pkgs, ... }: {
        home.file = {
            ".config/powerline" = {
                source = ../../dotfiles/build/powerline;
                recursive = true;
            };
        };

        programs.zsh = {
            enable = true;
            enableCompletion = false;
            loginExtra = ''
                # load system specific local configs
                if [ -r ~/.local/zshrc ]; then
                    source ~/.local/zshrc
                fi

                powerline-daemon -q --replace
                pythonDir="$(find /run/current-system/sw/lib/ -maxdepth 1 \( -type d -o -type l \) -iname "python*")"
                export POWERLINE_PYTHON="$pythonDir"
                source $pythonDir/site-packages/powerline/bindings/zsh/powerline.zsh
            '';
        };

        # The state version is required and should stay at the version you
        # originally installed.
        home.stateVersion = "24.11";
    };


    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [ zsh ];
    environment.pathsToLink = [ "/share/zsh" ];

    users.users.cbailey = {
        uid = 1000;
        isNormalUser = true;
        home = "/home/cbailey";
        shell = pkgs.zsh;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH2/jfutcgquJZEp2Y8OLflLREcNB7+j8ugsc9QiyhTS yubikey-125"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICaX+NiipC9sPhj9wyvpBTwatHmO8avPLEWdTVT/b+zR yubikey-224"
        ];
    };
    home-manager.users.cbailey = { pkgs, ... }: {
        home.file = {
            ".config/powerline" = {
                source = ../../dotfiles/cbailey/powerline;
                recursive = true;
            };
            ".gnupg/pubring.kbx" = {
                source = ../../dotfiles/pubring.kbx;
            };
            ".gitconfig" = {
                source = ../../dotfiles/gitconfig;
            };
            ".config/btop/btop.conf" = {
                source = ../../dotfiles/btop.conf;
            };
            ".ssh/rc" = {
                source = ../../dotfiles/ssh/rc;
            };
            ".ssh/config" = {
                source = ../../dotfiles/ssh/config;
            };
            ".vimrc" = {
                source = ../../dotfiles/vimrc;
            };
        };

        programs.fzf = {
            enable = true;
            enableZshIntegration = true;
            tmux.enableShellIntegration = true;
        };

        programs.tmux = {
            enable = true;
            aggressiveResize = true;
            clock24 = true;
            extraConfig = ''
                source $POWERLINE_PYTHON/site-packages/powerline/bindings/tmux/powerline.conf

                set -g default-terminal "screen-256color"
                set -g terminal-overrides 'xterm:colors=256'
                if-shell '[ $(echo "$(tmux -V | cut -d" " -f2) >= 2.1" | bc) -eq 1 ]' 'set -g mouse on'
                if-shell '[ $(echo "$(tmux -V | cut -d" " -f2) <= 2.1" | bc) -eq 1 ]' 'set -g mode-mouse on'
                if-shell '[ $(echo "$(tmux -V | cut -d" " -f2) <= 2.1" | bc) -eq 1 ]' 'set -g mouse-resize-pane on'
                if-shell '[ $(echo "$(tmux -V | cut -d" " -f2) <= 2.1" | bc) -eq 1 ]' 'set -g mouse-select-pane on'
                if-shell '[ $(echo "$(tmux -V | cut -d" " -f2) <= 2.1" | bc) -eq 1 ]' 'set -g mouse-select-window on'
                set -g history-limit 30000
                # pane movement
                bind-key j command-prompt -p "join pane from:"  "join-pane -h -s '%%'"
                bind-key s command-prompt -p "send pane to:"  "join-pane -t '%%'"
                bind-key b break-pane

                set -g status-right '#(env "$POWERLINE_COMMAND" $POWERLINE_COMMAND_ARGS tmux right -R pane_id=\"`tmux display -p "#""D"`\")'
            '';
        };

        programs.zsh = {
            enable = true;
            # zprof.enable = true;
            enableCompletion = lib.mkDefault true;
            completionInit = ''
                autoload -Uz compinit
                if [[ -n ''${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
                    compinit;
                else
                    compinit -C;
                fi;
            '';
            loginExtra = ''
                # Disable tmux for VS Code
                if [ -n "''${VSCODE_AGENT_FOLDER+1}" ]; then
                    export MORTIS_USE_TMUX=false
                fi

                # load system specific local configs
                if [ -r ~/.local/zshrc ]; then
                    source ~/.local/zshrc
                fi

                # init tmux start variable
                if [[ -z ''${MORTIS_USE_TMUX+x} ]]; then
                    export MORTIS_USE_TMUX=true
                fi

                powerline-daemon -q --replace
                pythonDir="$(find /run/current-system/sw/lib/ -maxdepth 1 \( -type d -o -type l \) -iname "python*")"
                export POWERLINE_PYTHON="$pythonDir"
                source $pythonDir/site-packages/powerline/bindings/zsh/powerline.zsh

                # auto-start tmux
                if [ "$MORTIS_USE_TMUX" = true ]; then
                    tmux-session
                fi
            '';

            zplug = {
                enable = true;
                plugins = [
                    {name = "zsh-users/zsh-autosuggestions";}
                ];
            };
        };

        # The state version is required and should stay at the version you
        # originally installed.
        home.stateVersion = "24.11";
    };
    home-manager.users.root = { pkgs, ... }: {
        home.file = {
            ".config/powerline" = {
                source = ../../dotfiles/root/powerline;
                recursive = true;
            };
            ".config/btop/btop.conf" = {
                source = ../../dotfiles/btop.conf;
            };
            ".vimrc" = {
                source = ../../dotfiles/vimrc;
            };
        };

        programs.fzf = {
            enable = true;
            enableZshIntegration = true;
            tmux.enableShellIntegration = true;
        };

        programs.zsh = {
            enable = true;
            enableCompletion = lib.mkDefault true;
            loginExtra = ''
                # load system specific local configs
                if [ -r ~/.local/zshrc ]; then
                    source ~/.local/zshrc
                fi

                powerline-daemon -q --replace
                pythonDir="$(find /run/current-system/sw/lib/ -maxdepth 1 \( -type d -o -type l \) -iname "python*")"
                export POWERLINE_PYTHON="$pythonDir"
                source $pythonDir/site-packages/powerline/bindings/zsh/powerline.zsh
            '';

            zplug = {
                enable = true;
                plugins = [
                    {name = "zsh-users/zsh-autosuggestions";}
                ];
            };
        };

        # The state version is required and should stay at the version you
        # originally installed.
        home.stateVersion = "24.11";
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
        btop
        git
        gnupg
        powerline
        python3
        tmux
        zsh
    ];

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableLsColors = true;
        enableBashCompletion = true;
        enableGlobalCompInit = false;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        shellInit = ''
            # envs
            export LESS='-R --use-color -Dd+r$Du+b'
            export MANPAGER="less -R --use-color -Dd+r -Du+b"
            export LC_ALL=en_US.UTF-8
            export LANG=en_US.UTF-8
            export EDITOR='vim'
            export VISUAL='vim'
            export PATH=$HOME/.bin:$HOME/.local/bin:$PATH

            #append into history file
            setopt INC_APPEND_HISTORY
            #save only one command if 2 common are same and consistent
            setopt HIST_IGNORE_DUPS
            #add timestamp for each entry
            setopt EXTENDED_HISTORY

            # Coloured man page support
            # using 'less' env vars (format is '\E[<brightness>;<colour>m')
            export LESS_TERMCAP_mb="\033[01;31m"     # begin blinking
            export LESS_TERMCAP_md="\033[01;31m"     # begin bold
            export LESS_TERMCAP_me="\033[0m"         # end mode
            export LESS_TERMCAP_so="\033[01;44;36m"  # begin standout-mode (bottom of screen)
            export LESS_TERMCAP_se="\033[0m"         # end standout-mode
            export LESS_TERMCAP_us="\033[00;36m"     # begin underline
            export LESS_TERMCAP_ue="\033[0m"         # end underline
        '';
        interactiveShellInit = ''
            bindkey -e
            bindkey '^R' history-incremental-search-backward
            bindkey "\e[3~" delete-char
            bindkey "^[[1;5C" forward-word
            bindkey "^[[1;5D" backward-word
        '';
        # loginShellInit = ''
        #     # login testy test
        #     # login test, please ignore
        # '';
        shellAliases = {
            diff = "diff --color=auto";
            grep = "grep --color=auto";
            ip = "ip -color=auto";
            la = "ls -la --color=auto";
            ll = "ls -l --color=auto";
            update = "sudo nixos-rebuild switch";
            rollback = "sudo nixos-rebuild switch --rollback";
        };
        histSize = 10000;
    };

    programs.vim = {
        enable = true;
        package = pkgs.vim-full;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        settings = {
            AcceptEnv = "LANG LC_* MORTIS_*";
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
            PermitRootLogin = "no";
            StreamLocalBindUnlink = true;
            X11Forwarding = true;
            X11UseLocalhost = false;
            TCPKeepAlive = true;
            AllowTcpForwarding = true;
        };
    };

    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
}
