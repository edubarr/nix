{ stateVersion, inputs, user, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules # Common modules
    ./modules # Local modules
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      homeStateVersion = stateVersion;
      inherit user;
    };
    users.${user} = import ../../home-manager/home.nix;
  };

  # Don't change it bro
  system.stateVersion = stateVersion;
}
