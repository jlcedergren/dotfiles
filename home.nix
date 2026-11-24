{ config, pkgs, lib, ... }:

let
  link = name: config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nix-config/${name}";
in
{
  home.username = "jillced";
  home.homeDirectory = "/Users/jillced";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    fd
    ripgrep
    gh
    htop
    nil
    nixfmt
  ];

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
    '' + lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      path=(/Applications/SuperCollider.app/Contents/MacOS(N/) $path)
      export MAXSDK="$HOME/max-sdk-base/c74support"
      export DOTNET_ROOT="/usr/local/share/dotnet"
    '' + ''
      [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
    '';

    profileExtra = ''
      PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
      export PATH

      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

  };

  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json";
      logo = {
        type = "auto";
        source = "macos";
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
    "aerospace".source = link "aerospace";
    "sketchybar".source = link "sketchybar";
    "karabiner".source = link "karabiner";
  };

  home.activation.librewolfChrome = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
    (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      dir="$HOME/Library/Application Support/librewolf/Profiles/me7og5ja.default-default/chrome"
      run mkdir -p "$dir"
      run install -m 644 ${./librewolf/chrome/userChrome.css} "$dir/userChrome.css"
      run install -m 644 ${./librewolf/chrome/userContent.css} "$dir/userContent.css"
    '');
}
