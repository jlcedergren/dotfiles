{ pkgs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "jillced";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.packages = with pkgs.nerd-fonts; [
    iosevka
    jetbrains-mono
    fira-code
    hack
    victor-mono
    symbols-only
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall";
    };

    taps = [
      "felixkratz/formulae"
      "nikitabobko/tap"
      "sikarugir-app/sikarugir"
    ];

    brews = [
      "curl" "faust" "yt-dlp"
      "felixkratz/formulae/sketchybar" "ghcup" "gnu-tar"
      "mu" "qt@5" "transmission-cli" "unzip" "mpv"
    ];

    casks = [
      "aerospace" "blender" "cardinal" "cycling74-max" "dotnet-sdk"
      "dotnet-sdk@10" "emacs-app" "font-cascadia-code-nf" "godot-mono"
      "inkscape" "krita" "librewolf" "mullvad-vpn" "notunes" "plugdata"
      "raspberry-pi-imager" "scribus" "signal" "sikarugir" "transmission"
      "ungoogled-chromium" "utm" "vlc" "kitty" "karabiner-elements"
    ];
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

}
