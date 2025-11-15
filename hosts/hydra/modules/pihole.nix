{ config, ... }:
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
  };

  services.pihole-web = {
    enable = true;
    openFirewall = true;
  };

  # Set Pi-hole as DNS server
  networking.nameservers = [ "127.0.0.1" ];
}