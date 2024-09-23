# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports = [ <home-manager/nixos> ];

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
    console.enable = false;
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

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.root.hashedPassword = "!";
    users.users.build = {
        isNormalUser = true;
        home = "/home/build";
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwDKM5fakow2MdR6YJ2qxX0TvAvqGbi9Dzugf04PM7z cbailey@angellus-pc"
        ];
    };
    nix.settings.trusted-users = [ "root" "build" ];

    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [ zsh ];
    users.users.cbailey = {
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
        programs.zsh = {
            enable = true;
            shellInit = ''
                # load system specific local configs
                if [ -r ~/.local/zshrc ]; then
                    source ~/.local/zshrc
                fi

                powerline-daemon -q --replace
                pythonDir=$(find /run/current-system/sw/lib/ \( -type d -o -type l \) -iname "*python*")
                source $pythonDir/site-packages/powerline/bindings/zsh/powerline.zsh
            '';

            home.file = {
                ".config/powerline" = {
                    source = ../../dotfiles/cbailey/powerline;
                    recursive = true;
                };
            };

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
        programs.zsh = {
            enable = true;
            shellInit = ''
                # Disable tmux for VS Code
                if [ -n "$\{VSCODE_AGENT_FOLDER+1}" ]; then
                    export USE_TMUX=false
                fi

                # load system specific local configs
                if [ -r ~/.local/zshrc ]; then
                    source ~/.local/zshrc
                fi

                # init tmux start variable
                if [[ -z $\{USE_TMUX+x} ]]; then
                    export USE_TMUX=true
                fi

                powerline-daemon -q --replace
                pythonDir=$(find /run/current-system/sw/lib/ \( -type d -o -type l \) -iname "*python*")
                source $pythonDir/site-packages/powerline/bindings/zsh/powerline.zsh

                # auto-start tmux
                # if [ "$USE_TMUX" = true ]; then
                #     tmux-session
                # fi
            '';

            home.file = {
                ".config/powerline" = {
                    source = ../../dotfiles/root/powerline;
                    recursive = true;
                };
            };

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
        powerline
        vim
        zsh
    ];

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableLsColors = true;
        enableBashCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;

        shellInit = ''
            # envs
            export LS_COLORS='rs=0:di=01;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:'
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
        };
        histSize = 10000;
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
    services.openssh.enable = true;

    networking.firewall.enable = true;
}
