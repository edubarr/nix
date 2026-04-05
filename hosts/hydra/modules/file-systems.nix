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

  fileSystems."/media/hd4" = {
    device = "UUID=0f2a23ec-6b54-469f-9461-215aadba3de0";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
    ];
  };

  #   fileSystems."/media/hd5" = {
  #   device = "UUID=cb663595-905a-4727-ba96-8f287c7cb69f";
  #   fsType = "ext4";
  #   options = [
  #     "defaults"
  #     "nofail"
  #   ];
  # };

  fileSystems."/media/all" = {
    device = "/media/hd*/share";
    fsType = "fuse.mergerfs";
    options = [
      "category.create=epmfs"
      "ignorepponrename=true"
      "defaults"
      "fsname=mergerfs"
      "allow_other"
      "nofail"
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
