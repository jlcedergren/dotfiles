# HM default
{ config, pkgs, link, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./fastfetch.nix
    ./librewolf.nix
  ];

  _module.args.link = name: config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nix-config/config/${name}";

  home.username = "jillced";
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
  ];

  programs.home-manager.enable = true;
  programs.fzf.enable = true;

  xdg.configFile = {
    "doom".source = link "doom";
    "kitty".source = link "kitty";
  };
}
