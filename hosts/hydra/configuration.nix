{ stateVersion, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./local-packages.nix
    ../../modules
  ];

  networking.hostName = hostname;

  # Don't change it bro
  system.stateVersion = stateVersion;

}