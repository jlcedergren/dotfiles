# Copies userChrome into every lw profile.
{ pkgs, lib, ... }:

let
  profiles = if pkgs.stdenv.hostPlatform.isDarwin
    then "$HOME/Library/Application Support/librewolf/Profiles"
    else "$HOME/.config/librewolf/librewolf";
in
{
  home.activation.librewolfChrome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for profile in "${profiles}"/*.default*; do
      [ -d "$profile" ] || continue
      run mkdir -p "$profile/chrome"
      run install -m 644 ${../config/librewolf/chrome/userChrome.css} "$profile/chrome/userChrome.css"
      run install -m 644 ${../config/librewolf/chrome/userContent.css} "$profile/chrome/userContent.css"
    done
  '';
}
