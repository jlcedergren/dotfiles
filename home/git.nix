{
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "jlcedergren";
      user.email = "jill@jillcedergren.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
