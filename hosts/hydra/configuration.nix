{ stateVersion, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules # Common modules
    ./modules # Local modules
  ];

  # Don't change it bro
  system.stateVersion = stateVersion;
}
