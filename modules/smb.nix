{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    shares = {
      hd0 = {
        path = "/media/hd0/share";
        comment = "Share for HD0";
        browseable = true;
        writable = true;
        guestOk = false;
        createMask = "0644";
        directoryMask = "0755";
      };
      hd2 = {
        path = "/media/hd2/share";
        comment = "Share for HD2";
        browseable = true;
        writable = true;
        guestOk = false;
        createMask = "0644";
        directoryMask = "0755";
      };
      hd3 = {
        path = "/media/hd3/share";
        comment = "Share for HD3";
        browseable = true;
        writable = true;
        guestOk = false;
        createMask = "0644";
        directoryMask = "0755";
      };
      hd4 = {
        path = "/media/hd4/share";
        comment = "Share for HD4";
        browseable = true;
        writable = true;
        guestOk = false;
        createMask = "0644";
        directoryMask = "0755";
      };
      all = {
        path = "/media/all";
        comment = "Aggregated share from multiple disks";
        browseable = true;
        writable = true;
        guestOk = false;
        createMask = "0644";
        directoryMask = "0755";
      };
    };
  };

  services.samba-wsdd = {
  enable = true;
  openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}