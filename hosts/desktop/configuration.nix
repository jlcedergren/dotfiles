# NixOS Desktop
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/sway.nix
    ../../modules/nixos/gaming.nix
  ];

  networking.hostName = "desktop";

  home-manager.users.jillced.imports = [ ../../home/dev.nix ];

  users.users.jillced.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGXrtZNhFXyYw08CbPr3HW0anr9m/55GRQfenT/LLUX jlc@datamaskin"
  ];
  services.openssh.settings.PasswordAuthentication = false;

  zramSwap.enable = true;

  # Nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.sway = {
    extraOptions = [ "--unsupported-gpu" ];
    extraSessionCommands = ''
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export LIBVA_DRIVER_NAME=nvidia
    '';
  };

  xdg.portal.wlr.settings.screencast = {
    output_name = "DP-2";
    chooser_type = "none";
    max_fps = 60;
  };

  environment.systemPackages = with pkgs; [
    vesktop proton-pass
  ];

  system.stateVersion = "26.05";
}
