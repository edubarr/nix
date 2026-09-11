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
- `backup.nix`: rsync mirrors of configs, Immich library, and the Samba backup folder to hd4/hd5.
- `local-packages.nix`: host-local package additions.
- `dev-env.nix`: host-local development environment.

Docker/OCI services live in `modules/containers/`:

- `pihole.nix`: DNS ad-blocking.
- `servarr.nix`: media automation stack.
- `glance.nix`: dashboard service.
- `immich.nix`: internal photo and video backup service.
- `it-tools.nix`: internal developer utilities.

## Backup

`backup.nix` mirrors data to the two 4TB backup disks (`hd4`, `hd5`) with daily systemd timers using `rsync`. `hd4` is the source of truth: configs and the Immich library are written under `bkp/hydra/<original path>`, and `backup-mirror` then mirrors the whole `hd4/bkp` tree to `hd5`. Deleted or changed config/library files are retained under `/media/hd4/.backup/{configs,immich}/` for 30 days, then pruned.

| Source | Written to |
|--------|-----------|
| `/srv/configs` | `/media/hd4/bkp/hydra/srv/configs` |
| `/media/hd3/immich` | `/media/hd4/bkp/hydra/media/hd3/immich` |
| `/media/hd4/bkp` (Samba + backups) | `/media/hd5/bkp` (full mirror) |

`backup-mirror` runs last, so `hd5` ends up as a full mirror of the `hd4` backup tree. The Immich PostgreSQL data directory and model cache are excluded from the mirror; a consistent `pg_dump` is written to `/srv/configs/immich/dump/immich.sql.gz` before each run, with dated copies kept in `history/daily` (last 7) and `history/weekly` (last 4) under the same `dump` directory. Offsite upload (Cloudflare R2 / Backblaze B2) is planned.

## Apply

```bash
sudo nixos-rebuild switch --flake .#hydra
```

This host does not include Home Manager in rebuilds.
