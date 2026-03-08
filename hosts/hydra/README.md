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
- `pihole.nix`: DNS ad-blocking.
- `servarr.nix`: media automation stack.
- `smb.nix`: samba file sharing.
- `file-systems.nix`: mounts and storage layout.
- `glance.nix`, `local-packages.nix`, `containers.nix`: additional host-local behavior.

## Apply

```bash
sudo nixos-rebuild switch --flake .#hydra
```

This host does not include Home Manager in rebuilds.
