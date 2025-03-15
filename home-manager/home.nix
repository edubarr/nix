{ homeStateVersion, user, ... }:
{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion; # Please read the comment before changing.

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}