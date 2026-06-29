{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.tmux
    pkgs.opencode
  ];

  programs.nix-ld = {
    enable = true;
  };
}
