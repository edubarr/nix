{
  services = {
    fstrim.enable = true;

    gnome.gnome-keyring.enable = true;

    upower.enable = true;

    gvfs.enable = true;
  };

  # Idk, swaylock needs it to work
  security.pam.services.swaylock = { };

  programs.dconf.enable = true;
}
