{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mergerfs
    git
    htop
    screen
  ];
}
