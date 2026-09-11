{ config, ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.pihole = {
      image = "pihole/pihole:latest";
      environmentFiles = [ "/srv/configs/pihole/.env" ];
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "8080:80/tcp"
      ];
      volumes = [
        "/srv/configs/pihole/pihole:/etc/pihole"
        "/srv/configs/pihole/dnsmasq.d:/etc/dnsmasq.d"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 8080 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  # Set Pi-hole as DNS server with fallback resolvers
  networking.nameservers = [
    "127.0.0.1"
    "1.1.1.1"
    "8.8.8.8"
    "2606:4700:4700::1111"
    "2001:4860:4860::8888"
  ];

  systemd.tmpfiles.rules = [
    "d /srv/configs/pihole 0755 root root -"
    "d /srv/configs/pihole/pihole 0755 root root -"
    "d /srv/configs/pihole/dnsmasq.d 0755 root root -"
  ];
}
