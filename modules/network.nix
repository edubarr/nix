{
  networking.networkmanager.enable = true;
  networking.firewall={
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  # Enable the SSH server
  services.openssh.enable = true;
}
