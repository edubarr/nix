{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
      };
      hd0 = {
        path = "/media/hd0/share";
        comment = "Share for HD0";
        browseable = "yes";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      hd1 = {
        path = "/media/hd1/share";
        comment = "Share for HD1";
        browseable = "yes";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      hd2 = {
        path = "/media/hd2/share";
        comment = "Share for HD2";
        browseable = "yes";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      hd3 = {
        path = "/media/hd3/share";
        comment = "Share for HD3";
        browseable = "yes";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      all = {
        path = "/media/all";
        comment = "Aggregated share from multiple disks";
        browseable = "yes";
        writable = "yes";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
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
