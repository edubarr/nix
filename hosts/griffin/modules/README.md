# griffin host modules

Host-specific NixOS modules for `griffin` (travel laptop).

## Scope

This directory has laptop-only behavior (Wayland session, NVIDIA hybrid graphics, desktop bluetooth UI).

## Modules

- `hyprland.nix`: Hyprland Wayland session, greetd login, portals, session variables.
- `nvidia.nix`: NVIDIA MX350 + Intel PRIME offload configuration.
- `bluetooth.nix`: enables `services.blueman` for desktop bluetooth management.

## Notes

- Cross-host defaults live in `modules/` at repo root.
- New host module files are imported from `hosts/griffin/modules/default.nix`.
