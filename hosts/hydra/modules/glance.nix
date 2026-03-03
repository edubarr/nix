{ ... }:
{
  virtualisation.oci-containers = {
    backend = "docker";
    containers.glance = {
      image = "glanceapp/glance:latest";
      ports = [ "8085:8080" ];
      volumes = [ "/srv/configs/glance:/app/config" ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /srv/configs/glance 0755 root root -"
  ];
}
