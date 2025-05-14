{
  fileSystems."/media/hd0" = {
    device = "UUID=196ee92b-8e40-4888-9711-392eb6fffd3e";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems."/media/hd1" = {
    device = "UUID=ac247179-e7a3-48bc-8722-610337b038f0";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/media/hd2" = {
    device = "UUID=0e783558-f6d7-4b74-8761-076f12a195f7";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems."/media/hd3" = {
    device = "UUID=3f742270-0c88-4f65-9313-55aeb6c31290";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  # fileSystems."/media/hd4" = {
  #   device = "UUID=b5fb7a72-96e5-4410-a87e-d1122fb38e8e";
  #   fsType = "ext4";
  #   options = [ "defaults" "nofail" ];
  # };

  fileSystems."/media/all" = {
    depends = [
      "/media/hd0"
      "/media/hd1"
      "/media/hd2"
      "/media/hd3"
    ];
    device = "/media/hd0/share:/media/hd1/share:/media/hd2/share:/media/hd3/share";
    fsType = "fuse.mergerfs";
    options = [
      "category.create=epmfs"
      "defaults"
      "fsname=mergerfs"
      "allow_other"
      "x-systemd.fail-gracefully"
    ];
  };

  # Bind mount servarr from its source directory on hd0
  fileSystems."/media/servarr" = {
    depends = [
      "/media/hd0"
    ];
    device = "/media/hd0/share/servarr_config";
    fsType = "none";
    options = [
      "bind"
      "nofail"
    ];
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
