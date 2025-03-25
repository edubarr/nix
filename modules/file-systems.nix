{
  fileSystems."/media/hd0" = {
    device = "UUID=196ee92b-8e40-4888-9711-392eb6fffd3e";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  # fileSystems."/media/hd1" = {
  #   device = "UUID=a45c14a8-a21d-4c37-9155-dc6674df6e79";
  #   fsType = "ext4";
  #   options = [ "defaults" "nofail" ];
  # };

  fileSystems."/media/hd2" = {
    device = "UUID=0e783558-f6d7-4b74-8761-076f12a195f7";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/media/hd3" = {
    device = "UUID=3f742270-0c88-4f65-9313-55aeb6c31290";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/media/hd4" = {
    device = "UUID=b5fb7a72-96e5-4410-a87e-d1122fb38e8e";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/media/all" = {
    device = "/media/hd0/share:/media/hd2/share:/media/hd3/share:/media/hd4/share";
    fsType = "fuse.mergerfs";
    options = [
      "category.create=epmfs"
      "defaults"
      "fsname=mergerfs"
      "allow_other"
      "nofail"
    ];
  };

  # Bind mount servarr from its source directory (adjust source path as needed)
  fileSystems."/media/servarr" = {
    device = "/media/hd0/share/servarr_config";
    fsType = "none";
    options = [ "bind" "nofail" ];
  };

  # Ensure directories are created at boot
  systemd.tmpfiles.rules = [
    "d /media/hd0 0755 root root -"
    "d /media/hd1 0755 root root -"
    "d /media/hd2 0755 root root -"
    "d /media/hd3 0755 root root -"
    "d /media/all 0755 root root -"
    "d /media/servarr 0755 root root -"
  ];
}