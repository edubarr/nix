# griffin

`griffin` is the traveling laptop host configuration.

## Role

- Mobile machine profile.
- Intended for portability-focused and personal workstation tasks.

## Files

- `configuration.nix`: host assembly entrypoint.
- `hardware-configuration.nix`: placeholder until generated on device.
- `modules/`: griffin-specific modules only.

## Host Modules

- `hyprland.nix`: Wayland session via Hyprland + greetd.
- `nvidia.nix`: NVIDIA MX350 + Intel hybrid PRIME offload config.
- `bluetooth.nix`: desktop bluetooth manager (`services.blueman.enable = true`).

## Bootstrap Notes

The hardware configuration is generated on the actual laptop and stored in `hardware-configuration.nix`.

## Apply

```bash
sudo nixos-rebuild switch --flake .#griffin
```

This host includes Home Manager in rebuilds.

## Hardware

- CPU: Intel i5-1135G7
- RAM: 16 GB DDR4
- GPU: Intel Iris Xe + NVIDIA MX350
