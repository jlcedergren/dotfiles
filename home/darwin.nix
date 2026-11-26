# macOS HM
{ lib, pkgs, link, ... }:

{
  home.homeDirectory = "/Users/jillced";

  home.packages = with pkgs; [ duti ];
  fonts.fontconfig.enable = false;

  programs.zsh = {
    initContent = lib.mkOrder 1020 ''
      path=(/Applications/SuperCollider.app/Contents/MacOS(N/) $path)
      export MAXSDK="$HOME/max-sdk-base/c74support"
      export DOTNET_ROOT="/usr/local/share/dotnet"
    '';

    profileExtra = ''
      PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"
      export PATH

      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    shellAliases.nup = "cd ~/nix-config && nix flake update && sudo darwin-rebuild switch --flake . && home-manager switch --flake . && doom upgrade";
  };

  programs.fastfetch.settings.logo.source = "macos";

  xdg.configFile = {
    "aerospace".source = link "aerospace";
    "sketchybar".source = link "sketchybar";
    "karabiner".source = link "karabiner";
  };

  home.file =
    let sc = "Library/Application Support/SuperCollider";
    in {
      "${sc}/startup.scd".source = link "supercollider/startup.scd";
      "${sc}/startup.normal.scd".source = link "supercollider/startup.normal.scd";
      "${sc}/startup.tidal.scd".source = link "supercollider/startup.tidal.scd";
    };
}
