{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.cockpit
  ];

  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };
}
