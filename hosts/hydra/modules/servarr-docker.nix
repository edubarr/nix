{ pkgs, lib, ... }:
let
  containerNames = [
    "plex"
    "qbittorrent"
    "prowlarr"
    "sonarr"
    "radarr"
    "bazarr"
    "heimdall"
    "jellyfin"
    "jellyseerr"
  ];
  ensureServarrNetwork = pkgs.writeShellScript "ensure-servarr-network" ''
    if ! ${pkgs.docker}/bin/docker network inspect servarr_network >/dev/null 2>&1; then
      ${pkgs.docker}/bin/docker network create servarr_network
    fi
  '';
in
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      plex = {
        image = "plexinc/pms-docker:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "32400:32400/tcp" ];
        volumes = [
          "/media/servarr/plexmediaserver:/config"
          "/media:/media"
        ];
        extraOptions = [
          "--network=servarr_network"
          "--device=/dev/dri:/dev/dri"
        ];
      };

      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        environment = { WEBUI_PORT = "8180"; };
        ports = [ "8180:8180" ];
        volumes = [
          "/media/servarr/qbittorrent:/config"
          "/media/all/servarr/downloads:/media/downloads"
        ];
        extraOptions = [ "--network=servarr_network" ];
      };

      prowlarr = {
        image = "ghcr.io/linuxserver/prowlarr:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "9696:9696" ];
        volumes = [ "/media/servarr/prowlarr:/config" ];
        extraOptions = [ "--network=servarr_network" ];
      };

      sonarr = {
        image = "ghcr.io/linuxserver/sonarr:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "8989:8989" ];
        volumes = [
          "/media/servarr/sonarr:/config"
          "/media/all/servarr:/media"
        ];
        extraOptions = [ "--network=servarr_network" ];
      };

      radarr = {
        image = "ghcr.io/linuxserver/radarr:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "7878:7878" ];
        volumes = [
          "/media/servarr/radarr:/config"
          "/media/all/servarr:/media"
        ];
        extraOptions = [ "--network=servarr_network" ];
      };

      bazarr = {
        image = "ghcr.io/linuxserver/bazarr:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "6767:6767" ];
        volumes = [
          "/media/servarr/bazarr:/config"
          "/media/all/servarr:/media"
        ];
        extraOptions = [ "--network=servarr_network" ];
      };

      heimdall = {
        image = "lscr.io/linuxserver/heimdall:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [
          "4080:80"
          "40443:443"
        ];
        volumes = [ "/media/servarr/heimdallconfig:/config" ];
        extraOptions = [ "--network=servarr_network" ];
      };

      jellyfin = {
        image = "lscr.io/linuxserver/jellyfin:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "8096:8096" ];
        volumes = [
          "/media/servarr/jellyfin:/config"
          "/media:/media"
        ];
        extraOptions = [
          "--network=servarr_network"
          "--device=/dev/dri:/dev/dri"
        ];
      };

      jellyseerr = {
        image = "fallenbagel/jellyseerr:latest";
        environmentFiles = [ "/media/servarr/.env" ];
        ports = [ "5055:5055" ];
        volumes = [ "/media/servarr/overseerr:/app/config" ];
        extraOptions = [ "--network=servarr_network" ];
      };
    };
  };

  systemd.services = {
    docker-network-servarr-network = {
      description = "Create docker network servarr_network";
      after = [ "docker.service" ];
      wants = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${ensureServarrNetwork}";
      };
    };
  } // lib.genAttrs (map (name: "docker-${name}") containerNames) (_: {
    after = [
      "media-servarr.mount"
      "docker-network-servarr-network.service"
    ];
    wants = [
      "media-servarr.mount"
      "docker-network-servarr-network.service"
    ];
    requires = [ "media-servarr.mount" ];
  });
}
