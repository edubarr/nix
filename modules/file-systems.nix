{
  fileSystems."/media/hd0" = {
    device = "UUID=3312f16f-0df7-4105-904a-05dc4e952ba5";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  fileSystems."/media/hd1" = {
    device = "UUID=a45c14a8-a21d-4c37-9155-dc6674df6e79";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  fileSystems."/media/hd2" = {
    device = "UUID=0e783558-f6d7-4b74-8761-076f12a195f7";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  fileSystems."/media/hd3" = {
    device = "UUID=3f742270-0c88-4f65-9313-55aeb6c31290";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  fileSystems."/media/all" = {
    device = "/media/hd0/share:/media/hd1/share:/media/hd2/share:/media/hd3/share";
    fsType = "fuse.mergerfs";
    options = [
      "category.create=epmfs"
      "defaults"
      "fsname=mergerfs"
      "allow_other"
    ];
  };

  # Bind mount servarr from its source directory (adjust source path as needed)
  fileSystems."/media/servarr" = {
    device = "/media/hd0/servarr_config";
    fsType = "none";
    options = [ "bind" ];
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