# NixOS Configuration

Personal NixOS configuration using Flakes for declarative system management.

## Overview

This repository manages multiple NixOS machines running NixOS 25.05 (unstable):

- `hydra` (homelab server)
- `griffin` (traveling laptop)
- `typhon` (main desktop/workstation)

Shared base modules are in `modules/`, and host-specific behavior lives in `hosts/<hostname>/modules/`.

`hydra` provides:

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

## Hosts

| Host | Type | Focus |
|------|------|-------|
| `hydra` | Headless server | Media, DNS, reverse proxy, storage, remote access |
| `griffin` | Laptop | Wayland (Hyprland), hybrid Intel+NVIDIA setup |
| `typhon` | Desktop | Wayland (Hyprland), NVIDIA desktop setup |

## Storage

Six HDDs mounted individually and pooled using mergerfs:

```
/media/hd0 - hd5    # Individual drives (ext4)
/media/all          # Merged pool (mergerfs, epmfs policy)
/media/servarr      # Bind mount for Servarr configs
```

Each drive's `/share` directory is combined into `/media/all` for unified storage with automatic file distribution.

## Documentation

- `hosts/hydra/README.md` - Homelab server host notes
- `hosts/griffin/README.md` - Traveling laptop host notes
- `hosts/typhon/README.md` - Main workstation host notes
- `modules/README.md` - Shared NixOS module guidelines
- `home-manager/README.md` - Home Manager usage and scope

## Repository Structure

```
.
├── flake.nix                 # Flake entry point
├── flake.lock                # Pinned dependencies
├── home-manager/
│   ├── README.md
│   └── home.nix              # User environment (edubarr)
├── hosts/
│   ├── hydra/
│   │   ├── README.md
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── modules/
│   ├── griffin/
│   │   ├── README.md
│   │   ├── configuration.nix
│   │   ├── hardware-configuration.nix
│   │   └── modules/           # bluetooth, hyprland, nvidia
│   └── typhon/
│       ├── README.md
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── modules/            # bluetooth, hyprland, nvidia
└── modules/
    ├── README.md
    └── *.nix                  # Shared modules imported by all hosts
```

## Usage

### Apply System Configuration

```bash
sudo nixos-rebuild switch --flake .#hydra
sudo nixos-rebuild switch --flake .#griffin
sudo nixos-rebuild switch --flake .#typhon
```

Home Manager integration on rebuild:

- `griffin`: enabled via `hosts/griffin/configuration.nix`
- `typhon`: enabled via `hosts/typhon/configuration.nix`
- `hydra`: not enabled

### Apply Home Manager Configuration
```bash
home-manager switch --flake .#edubarr
```

Standalone `home-manager switch` applies user config without a full system rebuild.

### Update Dependencies
```bash
nix flake update
```

### Validate Configuration
```bash
nix flake check
```

## Network

Hydra-specific network notes:

- **Tailscale**: Configured as exit node with subnet routing for `192.168.0.0/24`
- **Firewall**: Ports 22, 80, 443 open; Tailscale interface trusted
- **Cloudflare Tunnel**: Public access to Plex, Jellyfin, and Jellyseerr

## Secrets

Secrets are stored outside the repository:
- `/var/lib/acme/cloudflare-credentials` - Cloudflare API token for ACME
- `/var/lib/cloudflared/` - Tunnel credentials and certificates

## New Service Flow

1. `hosts/hydra/modules/<service>.nix` contains the new service module.
2. `hosts/hydra/modules/default.nix` imports the new module.
3. `hosts/hydra/modules/nginx.nix` contains the virtual host when web access is needed.
4. `sudo nixos-rebuild switch --flake .#hydra` applies the updated host configuration.
