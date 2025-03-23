{ pkgs, ... }:
{
  # enable docker
  # use docker without Root access (Rootless docker)
  virtualisation.docker = {
    enable = true;

    enableOnBoot = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  systemd.services.servarr-docker = {
    description = "Run docker-compose for servarr";
    after = [ "docker.service" "media-servarr.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/media/servarr";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose -f compose.yaml up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose -f compose.yaml down";
      Restart = "on-failure";
    };
  };
}
