{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "eduaraujobarros@gmail.com";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = "/var/lib/acme/cloudflare-credentials";
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    
    virtualHosts = 
      let
        makeVirtualHost = name: port: {
          "${name}.dudu.lat" = {
            enableACME = true;
            acmeRoot = null;
            forceSSL = true;
            locations."/" = {
              proxyPass = "http://127.0.0.1:${toString port}";
              proxyWebsockets = true;
            };
          };
        };

        services = [
          { name = "plex"; port = 32400; }
          { name = "sonarr"; port = 8989; }
          { name = "radarr"; port = 7878; }
          { name = "bazarr"; port = 6767; }
          { name = "prowlarr"; port = 9696; }
          { name = "qbit"; port = 8180; }
          { name = "heimdall"; port = 4080; }
        ];
      in
        builtins.foldl' (acc: svc: acc // makeVirtualHost svc.name svc.port) {} services;
  };
}