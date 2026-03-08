# Home Manager

This directory contains user-level Home Manager configuration.

It is configured for the shared user `edubarr` defined in `flake.nix`.

## Files

- `home.nix`: main Home Manager module for user `edubarr`.

## Apply

```bash
home-manager switch --flake .#edubarr
```

## Integration

- Home Manager is integrated into NixOS rebuilds on:
  - `griffin`
  - `typhon`
- `hydra` does not include Home Manager in host rebuild.
- Standalone apply is still available with `home-manager switch --flake .#edubarr`.

## Notes

- This is separate from host-level NixOS modules.
- This directory contains shell/editor/user app preferences.
- Current flake exposes: `homeConfigurations.edubarr`.
