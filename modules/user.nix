{ pkgs, user, ... }:
{
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users.${user} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA6AS3aaQ9Wga07/7xIbX9397I9wZLMJm2tqx7T8+4g/ eduaraujobarros@gmail.com"
      ];
    };
  };
}
