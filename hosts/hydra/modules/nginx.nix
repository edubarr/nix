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
          { name = "jellyfin"; port = 8096; }
          { name = "sonarr"; port = 8989; }
          { name = "radarr"; port = 7878; }
          { name = "bazarr"; port = 6767; }
          { name = "jellyseerr"; port = 5055; }
          { name = "prowlarr"; port = 9696; }
          { name = "qbit"; port = 8180; }
          { name = "heimdall"; port = 4080; }
        ];
      in
        builtins.foldl' (acc: svc: acc // makeVirtualHost svc.name svc.port) {} services;
  };

   # Cloudflare Tunnel Configuration
  services.cloudflared = {
    enable = true;
    tunnels = {
      "hydra-tunnel" = {
        credentialsFile = "/var/lib/cloudflared/hydra-tunnel-credentials.json";
        certificateFile = "/var/lib/cloudflared/cert.pem";
        default = "http_status:404";
        
        ingress = {
          # Define your services here
          "plex.dudu.lat" = "http://localhost:32400";
          "jellyfin.dudu.lat" = "http://localhost:8096";
          "jellyseerr.dudu.lat" = "http://localhost:5055";
        #   "sonarr.dudu.lat" = "http://localhost:8989";
        #   "radarr.dudu.lat" = "http://localhost:7878";
        #   "bazarr.dudu.lat" = "http://localhost:6767";
        #   "prowlarr.dudu.lat" = "http://localhost:9696";
        #   "qbit.dudu.lat" = "http://localhost:8180";
        #   "heimdall.dudu.lat" = "http://localhost:4080";
        };
      };
    };
  };
}