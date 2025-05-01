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
}
