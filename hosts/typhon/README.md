# typhon

`typhon` is the main desktop/workstation host configuration.

## Role

- Primary personal machine.
- Intended for desktop and heavier local workloads.

## Files

- `configuration.nix`: host assembly entrypoint.
- `hardware-configuration.nix`: placeholder until generated on device.
- `modules/`: typhon-specific modules only.

## Host Modules

- `hyprland.nix`: Wayland session via Hyprland + greetd.
- `nvidia.nix`: NVIDIA RTX 4060 graphics configuration.
- `bluetooth.nix`: desktop bluetooth manager (`services.blueman.enable = true`).

## Bootstrap Notes

The hardware configuration is generated on the actual machine and stored in `hardware-configuration.nix`.

## Apply

```bash
sudo nixos-rebuild switch --flake .#typhon
```

This host includes Home Manager in rebuilds.

## Hardware

- CPU: AMD Ryzen 5 7600
- RAM: 32 GB DDR5
- GPU: NVIDIA RTX 4060
