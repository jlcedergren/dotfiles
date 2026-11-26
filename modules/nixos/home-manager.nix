{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.jillced.imports = [
      ../../home
      ../../home/linux.nix
    ];
  };
}
