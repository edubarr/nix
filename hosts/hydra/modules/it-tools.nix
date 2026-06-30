{ ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.it-tools = {
      image = "ghcr.io/sharevb/it-tools:latest";
      ports = [ "127.0.0.1:8086:8080/tcp" ];
    };
  };
}
