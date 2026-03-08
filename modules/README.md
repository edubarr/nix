# Shared Modules

This directory contains NixOS modules shared by all hosts.

## Purpose

- Cross-host defaults are centralized in one place.
- Duplication across host configs is reduced.

## Loading

Modules are aggregated in `modules/default.nix` and imported by each host via:

- `../../modules` in `hosts/<hostname>/configuration.nix`

## Shared Modules

- `bluetooth.nix`: Bluetooth stack baseline (`hardware.bluetooth`), without desktop manager UI.
- `bootloader.nix`: systemd-boot + EFI variable support.
- `docker.nix`: rootless Docker defaults and daemon IPv6 settings.
- `garbage-collector.nix`: automatic weekly `nix.gc` cleanup policy.
- `graphics.nix`: generic graphics stack enablement (`hardware.graphics.enable`).
- `locale.nix`: locale defaults and keyboard layout settings.
- `network.nix`: sets `networking.hostName` from flake host `hostname`.
- `nix.nix`: Nix settings (`flakes`, `nix-command`) and unfree allowance.
- `sound.nix`: PipeWire audio stack with rtkit and PulseAudio compatibility.
- `swap.nix`: zram swap defaults.
- `system-services.nix`: shared system services (currently `fstrim`).
- `timezone.nix`: shared timezone default.
- `user.nix`: shared user baseline for `edubarr` (shell, groups, ssh key).

Machine-specific behavior lives in `hosts/<hostname>/modules/`.

## Host-Specific Examples

- `services.blueman.enable` is host-specific (enabled on `griffin` and `typhon`, not `hydra`).
- Wayland compositor and NVIDIA tuning are host-specific (`hosts/griffin/modules/`, `hosts/typhon/modules/`).
