{
  security.acme = {
    acceptTerms = true;
    defaults.email = "eduaraujobarros@gmail.com";
    # Use standalone mode for validation
    defaults.webroot = null;
    defaults.extraLegoFlags = ["--http.ipv6=true"];
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    # Enable IPv6
    enableIPv6 = true;
    
    virtualHosts."plex.dudu.lat" = {
      enableACME = true;
      forceSSL = true;
      # Listen on IPv6 as well
      listen = [
        { addr = "0.0.0.0"; port = 80; }
        { addr = "0.0.0.0"; port = 443; ssl = true; }
        { addr = "[::]"; port = 80; }
        { addr = "[::]"; port = 443; ssl = true; }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
        proxyWebsockets = true;
      };
    };
  };
}