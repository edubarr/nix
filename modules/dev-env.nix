{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.tmux
  ];

  programs.nix-ld = {
    enable = true;
  };
}
