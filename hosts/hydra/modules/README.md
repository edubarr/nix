# hydra host modules

Host-specific NixOS modules for `hydra`.

## Scope

This directory has services and behavior that run only on the homelab server host `hydra`.

## Modules

- `network.nix`: firewall, SSH, tailscale, and routing setup.
- `nginx.nix`: reverse proxy, ACME, and cloudflared tunnel.
- `pihole.nix`: DNS ad-blocking.
- `servarr.nix`: media automation stack.
- `smb.nix`: samba file sharing.
- `file-systems.nix`: mounts and storage layout.
- `glance.nix`: dashboard service.
- `local-packages.nix`: host-local package additions.
- `containers.nix`: host-local container settings.

## Notes

- Shared defaults live in `modules/` at repo root.
- New host module files are imported from `hosts/hydra/modules/default.nix`.
