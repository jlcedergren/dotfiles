# NixOS in vm
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  networking.hostName = "nixos-vm";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager.users.jillced.imports = [ ../../home/dev.nix ];

  services.xserver.xkb = {
    layout = "se";
    variant = "mac";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  users.users.jillced.packages = with pkgs; [ kdePackages.kate ];
  programs.firefox.enable = true;

  services.printing.enable = true;

  # UTM stuff
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  environment.systemPackages = with pkgs; [ wget ];

  system.stateVersion = "26.05";
}
