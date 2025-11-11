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
          "${name}.edubarr.dev" = {
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
          { name = "lanfin"; port = 8096; }
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
          "plex.edubarr.dev" = "http://localhost:32400";
          "jellyfin.edubarr.dev" = "http://localhost:8096";
          "jellyseerr.edubarr.dev" = "http://localhost:5055";
        #   "sonarr.edubarr.dev" = "http://localhost:8989";
        #   "radarr.edubarr.dev" = "http://localhost:7878";
        #   "bazarr.edubarr.dev" = "http://localhost:6767";
        #   "prowlarr.edubarr.dev" = "http://localhost:9696";
        #   "qbit.edubarr.dev" = "http://localhost:8180";
        #   "heimdall.edubarr.dev" = "http://localhost:4080";
        };
      };
    };
  };
}