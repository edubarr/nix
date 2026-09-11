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
          "/media/all/immich:/data"
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
        image = "docker.io/valkey/valkey:9@sha256:70739f85ad2ee01a726a965584a0f94895f01b0c60b3cc8b0aeef11eaa6888cf";
        extraOptions = [ "--network=immich_network" ];
      };

      immich-database = {
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23";
        environmentFiles = [ "/srv/configs/immich/.env" ];
        volumes = [ "/srv/configs/immich/postgres:/var/lib/postgresql/data" ];
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
          "media-all.mount"
        ];
        wants = [
          "docker.service"
          "docker-network-immich-network.service"
          "docker-immich-database.service"
          "docker-immich-redis.service"
          "media-all.mount"
        ];
        requires = [
          "docker-network-immich-network.service"
          "media-all.mount"
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
    "d /srv/configs/immich 0750 root root -"
    "d /srv/configs/immich/model-cache 0750 root root -"
    "d /srv/configs/immich/postgres 0750 root root -"
  ];
}
