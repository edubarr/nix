{ pkgs, ... }:
{
  environment.systemPackages = [ 
    pkgs.mergerfs
    pkgs.git
    pkgs.htop
  ];
}
