{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.netbird pkgs.ethtool ];

  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];

    trustedInterfaces = [ "wt0" ];
  };

  networking.tempAddresses = "default";

  # Enable the SSH server
  services.openssh.enable = true;

  # Enable netbird as a routing peer (LAN + exit node) and client
  services.netbird = {
    enable = true;
    useRoutingFeatures = "both";

    clients.default = {
      port = 51820;
      interface = "wt0";

      login = {
        enable = true;
        setupKeyFile = "/var/lib/netbird/setup-key";
      };
    };
  };

  systemd.services.ethtool-udp-gro = {
    description = "Enable UDP GRO forwarding optimizations for WireGuard (NetBird)";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = ''
      NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | ${pkgs.coreutils}/bin/cut -f 5 -d " ")
      ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off
    '';
  };
}
