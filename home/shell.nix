# zsh + starship. Platform stuff is in darwin.nix / linux.nix
{ config, lib, ... }:

{
  home.sessionVariables = {
    VISUAL = "emacs";
    EDITOR = "emacs";
    XDG_CONFIG_HOME = "$HOME/.config";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 500;
      nodejs.disabled = true;
      nix_shell.heuristic = true;
    };
  };

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

    initContent = lib.mkMerge [
      (lib.mkOrder 1010 ''
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
      '')
      (lib.mkOrder 1030 ''
        [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
      '')
    ];
  };
}
