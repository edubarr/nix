{
  fileSystems."/media/hd0" = {
    device = "UUID=ac247179-e7a3-48bc-8722-610337b038f0";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems."/media/hd1" = {
    device = "UUID=3f742270-0c88-4f65-9313-55aeb6c31290";
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
    device = "UUID=3206ac36-782f-4a00-83f1-967181742299";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems."/media/hd4" = {
    device = "UUID=58ec7053-c8e8-4fdb-b623-3e2e340b913a";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

    fileSystems."/media/hd5" = {
    device = "UUID=cf7c371a-decf-48b7-b1b2-6bfb3f2d2bcf";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  fileSystems."/media/all" = {
    device = "/media/hd0/share:/media/hd1/share:/media/hd2/share:/media/hd3/share:/media/hd4/share:/media/hd5/share";
    fsType = "fuse.mergerfs";
    options = [
      "category.create=epmfs"
      "ignorepponrename=true"
      "defaults"
      "fsname=mergerfs"
      "allow_other"
      "x-systemd.fail-gracefully"
    ];
  };


  # Ensure directories are created at boot
  systemd.tmpfiles.rules = [
    "d /srv/configs 0755 root root -"
    "d /media/hd0 0755 edubarr root -"
    "d /media/hd1 0755 edubarr root -"
    "d /media/hd2 0755 edubarr root -"
    "d /media/hd3 0755 edubarr root -"
    "d /media/hd4 0755 edubarr root -"
    "d /media/hd5 0755 edubarr root -"
    "d /media/all 0755 edubarr root -"
  ];
}
