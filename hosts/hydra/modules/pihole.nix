{ config, ... }:
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallWebserver = true;

    lists = [
      {
        url = "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/multi.txt";
        type = "block";
        enabled = true;
        description = "Hagezi Normal List";
      }
    ];
  };

  services.pihole-ftl.settings = {
    dns = {
      upstreams = [
        "1.1.1.1"
        "8.8.8.8"
        "2606:4700:4700::1111"  # Cloudflare IPv6
        "2001:4860:4860::8888"  # Google IPv6
      ];
    };
  };

  services.pihole-web = {
    enable = true;
    ports = [ 8080 ];
  };

  # Set Pi-hole as DNS server
  networking.nameservers = [ "127.0.0.1" ];
}