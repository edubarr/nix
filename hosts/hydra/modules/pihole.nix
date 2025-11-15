{ config, ... }:
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallWebserver = true;
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8080 ];
  };

  # Set Pi-hole as DNS server
  networking.nameservers = [ "127.0.0.1" ];
}