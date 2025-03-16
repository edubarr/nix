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

  users.users.edubarr = {
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA6AS3aaQ9Wga07/7xIbX9397I9wZLMJm2tqx7T8+4g/ eduaraujobarros@gmail.com"
    ];
  };

}