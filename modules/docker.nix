{
  # enable docker
  # use docker without Root access (Rootless docker)
  virtualisation.docker = {
    enable = true;

    enableOnBoot = false;
    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "fd00:dead:beef::/64";
      ip6tables = true;
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
