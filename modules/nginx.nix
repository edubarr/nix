{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "eduaraujobarros@gmail.com";
      dnsProvider = "cloudflare";  # Match your provider
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = "/var/lib/acme/cloudflare-credentials";
    };
    # certs."dudu.lat" = {
    #   domain = "*.dudu.lat";
    #   extraDomainNames = ["dudu.lat"];  # Include apex domain
      
    # };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    
    virtualHosts."plex.dudu.lat" = {
      enableACME = true;
      acmeRoot = null;
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