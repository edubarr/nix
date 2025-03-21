{
  networking.networkmanager.enable = true;
  networking.firewall={
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
  };

  # Enable the SSH server
  services.openssh.enable = true;

  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "eduaraujobarros@gmail.com";  # update to your real email
  # };

  # services.nginx = {
  #   enable = true;
  #   recommendedProxySettings = true;
  #   recommendedTlsSettings = true;
  #   virtualHosts."plex.dudu.lat" = {
  #     enableACME = true;
  #     forceSSL = true;
  #     root = "/var/www/plex.dudu.lat"; # optional: adjust or remove if not needed
  #     locations."/ " = {
  #       # adjust the proxy pass to match your setup; this example proxies to HTTPS on localhost:32400
  #       proxyPass = "https://127.0.0.1:32400";
  #       proxyWebsockets = true;
  #       # extraConfig =
  #       #   "proxy_ssl_server_name on;" +
  #       #   "proxy_pass_header Authorization;";
  #     };
  #   };
  # };
}
