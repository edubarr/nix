{ pkgs, ... }:
{
  environment.systemPackages = [ 
    pkgs.mergerfs
  ];
}
