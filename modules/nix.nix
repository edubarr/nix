{
  # Forgive me, Stallman sensei
  nixpkgs.config.allowUnfree = true;

  # I use flakes btw
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
