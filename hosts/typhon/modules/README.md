# typhon host modules

Host-specific NixOS modules for `typhon` (main desktop).

## Scope

This directory has desktop-only behavior (Wayland session, NVIDIA desktop graphics, desktop bluetooth UI).

## Modules

- `hyprland.nix`: Hyprland Wayland session, greetd login, portals, session variables.
- `nvidia.nix`: NVIDIA RTX 4060 graphics configuration.
- `bluetooth.nix`: enables `services.blueman` for desktop bluetooth management.

## Notes

- Cross-host defaults live in `modules/` at repo root.
- New host module files are imported from `hosts/typhon/modules/default.nix`.
