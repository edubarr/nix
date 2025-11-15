{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.tailscale ];

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ config.services.tailscale.port ];

    trustedInterfaces = [ "tailscale0" ];
  };

  networking.tempAddresses = "default";

  networking.nameservers = [ "192.168.0.10" ];

  # Enable IP forwarding for subnet routing
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  # Enable the SSH server
  services.openssh.enable = true;

  # Enable tailscale
  services.tailscale.enable = true;

  systemd.services.tailscale-autoconnect = {
  description = "Automatic connection to Tailscale";

  # make sure tailscale is running before trying to connect to tailscale
  after = [ "network-pre.target" "tailscale.service" ];
  wants = [ "network-pre.target" "tailscale.service" ];
  wantedBy = [ "multi-user.target" ];

  # set this service as a oneshot job
  serviceConfig.Type = "oneshot";

  # have the job run the init script
  script = with pkgs; ''
    # wait for tailscaled to settle
    sleep 2

    # connect or update tailscale with advertised routes and exit node
    ${tailscale}/bin/tailscale up -authkey tskey-example --advertise-routes=192.168.0.0/24 --advertise-exit-node
  '';
};
}
