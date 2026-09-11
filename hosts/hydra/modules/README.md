# hydra host modules

Host-specific NixOS modules for `hydra`.

## Scope

This directory has services and behavior that run only on the homelab server host `hydra`.

## Modules

- `network.nix`: firewall, SSH, netbird, and routing setup.
- `nginx.nix`: reverse proxy, ACME, and cloudflared tunnel.
- `file-systems.nix`: mounts and storage layout.
- `smb.nix`: samba file sharing.
- `backup.nix`: rsync mirrors of configs and Immich to `hd4`/`hd5`, plus the `hd4` Samba backup folder mirrored to `hd5`. Immich DB dumps keep 7 daily + 4 weekly copies.
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
- Immich library lives on `/media/hd3/immich` and is written to `/media/hd4/bkp/hydra/media/hd3/immich` by `backup.nix`, then mirrored to `hd5`.
- The Samba `bkp` share is `/media/hd4/bkp`; `backup.nix` mirrors it to `/media/hd5/bkp`.
- Automated backups are namespaced under `bkp/hydra/<original path>` (for example `/srv/configs` → `bkp/hydra/srv/configs`).
- Immich DB dumps are kept as 7 daily and 4 weekly files in `/srv/configs/immich/dump/history/{daily,weekly}`; the config/library versioning under `/media/hd4/.backup` does not apply to the dump directory.
- Changed/deleted config and library files are archived under `/media/hd4/.backup/{configs,immich}/<date>` and pruned after 30 days (`backupRetentionDays` in `backup.nix`).
