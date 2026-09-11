# hydra

`hydra` is the homelab server host configuration.

## Role

- Always-on home services host.
- Runs media, DNS, reverse proxy, VPN, and storage workloads.

## Files

- `configuration.nix`: host assembly entrypoint.
- `hardware-configuration.nix`: machine-generated hardware config.
- `modules/`: hydra-specific modules only.

## Host Modules

- `network.nix`: firewall, SSH, tailscale, and routing setup.
- `nginx.nix`: reverse proxy, ACME, and cloudflared tunnel.
- `smb.nix`: samba file sharing.
- `file-systems.nix`: mounts and storage layout.
- `local-packages.nix`: host-local package additions.
- `dev-env.nix`: host-local development environment.

Docker/OCI services live in `modules/containers/`:

- `pihole.nix`: DNS ad-blocking.
- `servarr.nix`: media automation stack.
- `glance.nix`: dashboard service.
- `immich.nix`: internal photo and video backup service.
- `it-tools.nix`: internal developer utilities.

## Apply

```bash
sudo nixos-rebuild switch --flake .#hydra
```

This host does not include Home Manager in rebuilds.
