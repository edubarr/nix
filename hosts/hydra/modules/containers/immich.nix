{ pkgs, lib, ... }:
let
  containerNames = [
    "immich-server"
    "immich-machine-learning"
    "immich-redis"
    "immich-database"
  ];

  ensureImmichNetwork = pkgs.writeShellScript "ensure-immich-network" ''
    if ! ${pkgs.docker}/bin/docker network inspect immich_network >/dev/null 2>&1; then
      ${pkgs.docker}/bin/docker network create immich_network
    fi
  '';
in
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      immich-server = {
        image = "ghcr.io/immich-app/immich-server:v3";
        environment = {
          DB_HOSTNAME = "immich-database";
          IMMICH_MACHINE_LEARNING_URL = "http://immich-machine-learning:3003";
          REDIS_HOSTNAME = "immich-redis";
        };
        # Defines DB_* for Immich and matching POSTGRES_* variables for PostgreSQL.
        environmentFiles = [ "/srv/configs/immich/.env" ];
        ports = [ "2283:2283/tcp" ];
        volumes = [
          "/media/hd3/immich:/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [ "--network=immich_network" ];
      };

      immich-machine-learning = {
        image = "ghcr.io/immich-app/immich-machine-learning:v3";
        environmentFiles = [ "/srv/configs/immich/.env" ];
        volumes = [ "/srv/configs/immich/model-cache:/cache" ];
        extraOptions = [ "--network=immich_network" ];
      };

      immich-redis = {
        image = "docker.io/valkey/valkey:9";
        extraOptions = [ "--network=immich_network" ];
      };

      immich-database = {
        image = "ghcr.io/immich-app/postgres:18-vectorchord1.1.1-pgvector0.8.5";
        environmentFiles = [ "/srv/configs/immich/.env" ];
        volumes = [ "/srv/configs/immich/postgres:/var/lib/postgresql" ];
        extraOptions = [
          "--network=immich_network"
          "--shm-size=128mb"
        ];
      };
    };
  };

  systemd.services =
    lib.genAttrs (map (name: "docker-${name}") containerNames) (_: {
      after = [
        "docker.service"
        "docker-network-immich-network.service"
      ];
      wants = [
        "docker.service"
        "docker-network-immich-network.service"
      ];
      requires = [ "docker-network-immich-network.service" ];
    })
    // {
      docker-immich-server = {
        after = [
          "docker.service"
          "docker-network-immich-network.service"
          "docker-immich-database.service"
          "docker-immich-redis.service"
          "media-hd3.mount"
        ];
        wants = [
          "docker.service"
          "docker-network-immich-network.service"
          "docker-immich-database.service"
          "docker-immich-redis.service"
          "media-hd3.mount"
        ];
        requires = [
          "docker-network-immich-network.service"
          "media-hd3.mount"
        ];
      };

      docker-network-immich-network = {
        description = "Create docker network immich_network";
        after = [ "docker.service" ];
        wants = [ "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${ensureImmichNetwork}";
        };
      };
    };

  systemd.tmpfiles.rules = [
    "d /srv/configs/immich 0755 root root -"
    "d /srv/configs/immich/model-cache 0750 root root -"
    "d /srv/configs/immich/postgres 0750 root root -"
  ];
}
