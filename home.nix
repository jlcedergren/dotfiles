{ config, pkgs, lib, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  link = name: config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nix-config/${name}";
in
{
  home.username = "jillced";
  home.homeDirectory = if isDarwin then "/Users/jillced" else "/home/jillced";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fd
    ripgrep
    htop
    nil
    nixfmt
    zstd
    chromaprint
    clang-tools
    cmake
    go
    isync
    gtop
    nmap
    wget
    unar
  ] ++ lib.optionals isDarwin [
    duti
  ] ++ lib.optionals (!isDarwin) [
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: [ epkgs.vterm ]))
    nerd-fonts.symbols-only

    dotnet-sdk_10
    csharp-ls

    nodejs
    typescript-language-server

    python3
    pyright

    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy

    gcc
    gnumake
    gdb

    vscode-langservers-extracted

    shellcheck
  ];  fonts.fontconfig.enable = !isDarwin;

  programs.home-manager.enable = true;

  programs.fzf.enable = true;

  # Git config
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "jlcedergren";
      user.email = "jill@jillcedergren.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # Starship config
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 500;
      nodejs.disabled = true;
      nix_shell.heuristic = true;
    };
  };

  # ZSH config
  home.sessionVariables = {
    VISUAL = "emacs";
    EDITOR = "emacs";
    XDG_CONFIG_HOME = "$HOME/.config";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";

    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 10000;
      save = 10000;
    };

    envExtra = ''
      [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    '';

    initContent = ''
      typeset -U path
      path=(
        ~/bin(N/)
        ~/.config/emacs/bin(N/)
        ~/.ghcup/bin(N/)
        ~/go/bin(N/)
        $path
      )

      bindkey -M vicmd 'ä' vi-end-of-line

      if [[ $OSTYPE == darwin* ]]; then
        _clip_copy()  { pbcopy }
        _clip_paste() { pbpaste }
      elif [[ -n $WAYLAND_DISPLAY ]] && (( $+commands[wl-copy] )); then
        _clip_copy()  { wl-copy }
        _clip_paste() { wl-paste --no-newline }
      fi

      if (( $+functions[_clip_copy] )); then
        vi-put-after-clipboard()  { CUTBUFFER=$(_clip_paste); zle vi-put-after }
        vi-put-before-clipboard() { CUTBUFFER=$(_clip_paste); zle vi-put-before }
        vi-yank-clipboard()       { zle vi-yank; print -rn -- "$CUTBUFFER" | _clip_copy }
        zle -N vi-put-after-clipboard
        zle -N vi-put-before-clipboard
        zle -N vi-yank-clipboard
        bindkey -M vicmd 'p' vi-put-after-clipboard
        bindkey -M vicmd 'P' vi-put-before-clipboard
        bindkey -M vicmd 'y' vi-yank-clipboard
      fi


      path+=(~/.dotnet/tools(N/))

      csnew() {
        mkdir -p "$1" && cd "$1" || return
        dotnet new sln -n "$1" --format sln
        dotnet new console -n "$1" --use-program-main
        dotnet sln add "$1/$1.csproj"
        dotnet new gitignore
        touch .projectile
        git init
      }
    '' + lib.optionalString isDarwin ''
      path=(/Applications/SuperCollider.app/Contents/MacOS(N/) $path)
      export MAXSDK="$HOME/max-sdk-base/c74support"
      export DOTNET_ROOT="/usr/local/share/dotnet"
    '' + ''
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
    '';

    profileExtra = lib.optionalString isDarwin ''
      PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
      export PATH

      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases = {
      nup = if isDarwin
        then "cd ~/nix-config && nix flake update && sudo darwin-rebuild switch --flake . && home-manager switch --flake . && doom upgrade"
        else "cd ~/nix-config && nix flake update && sudo nixos-rebuild switch --flake . && doom upgrade";
    } // lib.optionalAttrs (!isDarwin) {
      nrs = "sudo nixos-rebuild switch --flake ~/nix-config";
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
      logo = {
        type = "auto";
        width = 65;
        height = 35;
        padding = {
          top = 0;
          left = 0;
          right = 2;
        };
        color = {
          "1" = "#5BCEFA";
          "2" = "#F5A9B8";
          "3" = "#FFFFFF";
          "4" = "#FFFFFF";
          "5" = "#F5A9B8";
          "6" = "#5BCEFA";
        };
      } // lib.optionalAttrs isDarwin {
        source = "macos";
      };
      modules = [
        "title" "separator" "os" "host" "kernel" "uptime" "packages"
        "shell" "display" "de" "wm" "wmtheme" "theme" "icons" "font"
        "cursor" "terminal" "terminalfont" "cpu" "gpu" "memory" "swap"
        "disk" "localip" "battery" "poweradapter" "locale" "break" "colors"
      ];
    };
  };

  xdg.configFile = {
    "doom".source = link "doom";
    "kitty".source = link "kitty";
  } // lib.optionalAttrs isDarwin {
    "aerospace".source = link "aerospace";
    "sketchybar".source = link "sketchybar";
    "karabiner".source = link "karabiner";  }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    "sway".source = link "sway";
    "waybar".source = link "waybar";
  };

  home.activation.librewolfChrome =
    let
      profiles = if isDarwin
        then "$HOME/Library/Application Support/librewolf/Profiles"
        else "$HOME/.config/librewolf/librewolf";
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for profile in "${profiles}"/*.default*; do
        [ -d "$profile" ] || continue
        run mkdir -p "$profile/chrome"
        run install -m 644 ${./librewolf/chrome/userChrome.css} "$profile/chrome/userChrome.css"
        run install -m 644 ${./librewolf/chrome/userContent.css} "$profile/chrome/userContent.css"
      done
    '';

  home.file = lib.mkIf isDarwin (
    let sc = "Library/Application Support/SuperCollider";
    in {
      "${sc}/startup.scd".source = link "supercollider/startup.scd";
      "${sc}/startup.normal.scd".source = link "supercollider/startup.normal.scd";
      "${sc}/startup.tidal.scd".source = link "supercollider/startup.tidal.scd";
    }
  );

  dconf.settings = lib.mkIf (!isDarwin) {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  gtk = lib.mkIf (!isDarwin) {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
