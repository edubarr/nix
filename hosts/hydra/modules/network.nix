{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.tailscale pkgs.ethtool ];

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ config.services.tailscale.port ];

    trustedInterfaces = [ "tailscale0" ];
  };

  networking.tempAddresses = "default";

  # Enable IP forwarding for subnet routing
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  # Enable the SSH server
  services.openssh.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;

    systemd.services.ethtool-udp-gro = {
    description = "Enable UDP GRO forwarding optimizations for Tailscale";

    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = ''
      NETDEV=$(${pkgs.iproute2}/bin/ip -o route get 8.8.8.8 | ${pkgs.coreutils}/bin/cut -f 5 -d " ")
      ${pkgs.ethtool}/bin/ethtool -K $NETDEV rx-udp-gro-forwarding on rx-gro-list off
    '';
  };

  systemd.services.tailscale-autoconnect = {
  description = "Automatic connection to Tailscale";

  # make sure tailscale is running before trying to connect to tailscale
  after = [ "network-pre.target" "tailscale.service" "ethtool-udp-gro.service" ];
  wants = [ "network-pre.target" "tailscale.service" "ethtool-udp-gro.service" ];
  wantedBy = [ "multi-user.target" ];

  # set this service as a oneshot job
  serviceConfig.Type = "oneshot";

  # have the job run the init script
  script = with pkgs; ''
    # wait for tailscaled to settle
    sleep 2

    # connect or update tailscale with advertised routes and exit node
    ${tailscale}/bin/tailscale up --advertise-routes=192.168.0.0/24 --advertise-exit-node
  '';
  };
}
