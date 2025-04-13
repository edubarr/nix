{
  networking.networkmanager.enable = true;
  networking.firewall={
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  networking.tempAddresses = "default";

  # Enable the SSH server
  services.openssh.enable = true;
}
