# NixOS HM stuff
{ pkgs, link, ... }:

{
  home.homeDirectory = "/home/jillced";

  home.packages = with pkgs; [
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: [ epkgs.vterm ]))
    nerd-fonts.symbols-only
  ];
  fonts.fontconfig.enable = true;

  programs.zsh.shellAliases = {
    nup = "cd ~/nix-config && nix flake update && sudo nixos-rebuild switch --flake . && doom upgrade";
    nrs = "sudo nixos-rebuild switch --flake ~/nix-config";
  };

  xdg.configFile = {
    "sway".source = link "sway";
    "waybar".source = link "waybar";
    "wofi".source = link "wofi";
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
