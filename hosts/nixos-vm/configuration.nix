# NixOS in UTM on the M1 Mac.
# Based on what the installer generated; the hardware-specific
# parts live in hardware-configuration.nix next to this file.

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network
  networking.hostName = "nixos-vm";
  networking.networkmanager.enable = true;

  # Locale and keyboard
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  services.xserver.xkb = {
    layout = "se";
    variant = "mac";
  };
  console.keyMap = "sv-latin1";

  # Desktop: KDE Plasma
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  # VM integration with UTM
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  services.openssh.enable = true;

  # User
  users.users.jillced = {
    isNormalUser = true;
    description = "jillced";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ kdePackages.kate ];
  };

  # zsh has to be enabled system-wide to be a login shell;
  # the actual config comes from home.nix
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # Never change this after the install (same rule as on the Mac)
  system.stateVersion = "26.05";
}
