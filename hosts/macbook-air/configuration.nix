# MacBook Air M1 (nix-darwin)
{ pkgs, ... }:

{
  imports = [
    ../../modules/shared/nix.nix
    ./homebrew.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "jillced";

  fonts.packages = with pkgs.nerd-fonts; [
    iosevka
    jetbrains-mono
    fira-code
    hack
    victor-mono
    symbols-only
  ];
}
