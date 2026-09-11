# hydra host modules

Host-specific NixOS modules for `hydra`.

## Scope

This directory has services and behavior that run only on the homelab server host `hydra`.

## Modules

- `network.nix`: firewall, SSH, tailscale, and routing setup.
- `nginx.nix`: reverse proxy, ACME, and cloudflared tunnel.
- `file-systems.nix`: mounts and storage layout.
- `smb.nix`: samba file sharing.
- `local-packages.nix`: host-local package additions.
- `dev-env.nix`: host-local development environment.

### Containers

Docker/OCI services live in `containers/`:

- `pihole.nix`: DNS ad-blocking.
- `servarr.nix`: media automation stack.
- `glance.nix`: dashboard service.
- `immich.nix`: internal photo and video backup service.
- `it-tools.nix`: internal developer utilities.

## Notes

- Shared defaults live in `modules/` at repo root.
- New host module files are imported from `hosts/hydra/modules/default.nix`.
- Immich reads `/srv/configs/immich/.env` with `DB_*`/`POSTGRES_*` variables.
