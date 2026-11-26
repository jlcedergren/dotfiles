{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
    (heroic.override {
      extraPkgs = pkgs': [ pkgs'.gamemode ];
    })
  ];
}
