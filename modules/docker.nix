{ pkgs, ... }:
{
  # enable docker
  # use docker without Root access (Rootless docker)
  virtualisation.docker = {
    enable = true;

    enableOnBoot = false;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # # Create a systemd service to run docker-compose on /media/servarr
  # systemd.services.servarr-docker = {
  #   description = "Run docker-compose for servarr";
  #   after = [ "docker.service" "media-servarr.mount" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     WorkingDirectory = "/media/servarr";
  #     ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f docker-compose.yaml up -d";
  #     ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f docker-compose.yaml down";
  #     Restart = "on-failure";
  #   };
  # };
}
