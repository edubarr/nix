# NixOS Configuration

Personal NixOS configuration using Flakes for declarative system management.

## Overview

This repository manages **hydra**, a home server running NixOS 25.05 (unstable). The configuration provides:

- Media server and automation (Servarr stack)
- Network-wide ad blocking (Pi-hole)
- Secure remote access (Tailscale VPN)
- File sharing (Samba)
- Reverse proxy with automatic SSL (Nginx + Let's Encrypt)
- External access via Cloudflare Tunnels

## Services

### Media Stack (Docker)
| Service | Port | Description |
|---------|------|-------------|
| Plex | 32400 | Media streaming server |
| Jellyfin | 8096 | Open-source media server |
| Jellyseerr | 5055 | Media request management |
| Sonarr | 8989 | TV show automation |
| Radarr | 7878 | Movie automation |
| Bazarr | 6767 | Subtitle automation |
| Prowlarr | 9696 | Indexer manager |
| qBittorrent | 8180 | Torrent client |
| Heimdall | 4080 | Application dashboard |

### Infrastructure
| Service | Port | Description |
|---------|------|-------------|
| Pi-hole | 8080 | DNS ad blocking |
| Cockpit | 9090 | Web-based server management |
| Nginx | 80/443 | Reverse proxy with ACME/SSL |
| SSH | 22 | Secure shell access |
| Samba | 445 | Windows file sharing |
| Tailscale | - | VPN mesh network (exit node) |

All services are available at `<service>.edubarr.dev` with automatic SSL certificates via Cloudflare DNS challenge.

## Storage

Six HDDs mounted individually and pooled using mergerfs:

```
/media/hd0 - hd5    # Individual drives (ext4)
/media/all          # Merged pool (mergerfs, epmfs policy)
/media/servarr      # Bind mount for Servarr configs
```

Each drive's `/share` directory is combined into `/media/all` for unified storage with automatic file distribution.

## Repository Structure

```
.
├── flake.nix                 # Flake entry point
├── flake.lock                # Pinned dependencies
├── home-manager/
│   └── home.nix              # User environment (edubarr)
├── hosts/
│   └── hydra/
│       ├── configuration.nix # Host configuration
│       ├── hardware-configuration.nix
│       └── modules/
│           ├── cockpit.nix       # Web management UI
│           ├── file-systems.nix  # HDD mounts + mergerfs
│           ├── network.nix       # Tailscale + firewall
│           ├── nginx.nix         # Reverse proxy + Cloudflare tunnel
│           ├── pihole.nix        # DNS ad blocking
│           ├── servarr-docker.nix # Media stack
│           └── smb.nix           # Samba shares
└── modules/                  # Shared modules
    ├── bluetooth.nix
    ├── bootloader.nix        # systemd-boot
    ├── docker.nix            # Rootless Docker
    ├── garbage-collector.nix # Nix store cleanup
    ├── graphics.nix
    ├── locale.nix            # pt_BR locale
    ├── nix.nix               # Flakes + unfree
    ├── sound.nix             # PipeWire
    ├── swap.nix              # ZRAM
    ├── system-services.nix   # fstrim
    ├── timezone.nix          # America/Maceio
    └── user.nix              # User account
```

## Usage

### Apply System Configuration
```bash
sudo nixos-rebuild switch --flake .#hydra
```

### Apply Home Manager Configuration
```bash
home-manager switch --flake .#edubarr
```

### Update Dependencies
```bash
nix flake update
```

### Validate Configuration
```bash
nix flake check
```

## Network

- **Tailscale**: Configured as exit node with subnet routing for `192.168.0.0/24`
- **Firewall**: Ports 22, 80, 443 open; Tailscale interface trusted
- **Cloudflare Tunnel**: Public access to Plex, Jellyfin, and Jellyseerr

## Secrets

Secrets are stored outside the repository:
- `/var/lib/acme/cloudflare-credentials` - Cloudflare API token for ACME
- `/var/lib/cloudflared/` - Tunnel credentials and certificates

## Adding a New Service

1. Create `hosts/hydra/modules/<service>.nix`
2. Add import to `hosts/hydra/modules/default.nix`
3. Add nginx virtual host entry in `nginx.nix` (if web-accessible)
4. Rebuild: `sudo nixos-rebuild switch --flake .#hydra`
