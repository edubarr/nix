# AGENTS.md

Operational guide for coding agents working in this repository.

## Repository Overview

- Type: NixOS + Home Manager flake repository.
- Hosts: `hydra` (homelab server), `griffin` (travel laptop), `typhon` (desktop).
- Flake root: `flake.nix`.
- Shared modules: `modules/*.nix` via `modules/default.nix`.
- Host modules: `hosts/<host>/modules/*.nix` via each host `modules/default.nix`.
- Home Manager source: `home-manager/home.nix`.

## Cursor/Copilot Rule Files

Checked locations:

- `.cursor/rules/`
- `.cursorrules`
- `.github/copilot-instructions.md`

Current state: none of these files exist in this repository.

## Architecture Notes

- `flake.nix` creates `nixosConfigurations` for all three hosts from a host list.
- `specialArgs` injects `hostname`, `stateVersion`, `user`, and `inputs`.
- `networking.hostName` is set in shared `modules/network.nix` from `hostname`.
- Home Manager integration differs by host:
  - `griffin`: integrated in `hosts/griffin/configuration.nix`
  - `typhon`: integrated in `hosts/typhon/configuration.nix`
  - `hydra`: no HM integration in host rebuild
- Standalone HM output exists: `homeConfigurations.edubarr`.

## Build Commands

Run from repo root (`/home/eduardo/code/nix`).

```bash
# Build and switch one host
sudo nixos-rebuild switch --flake .#hydra
sudo nixos-rebuild switch --flake .#griffin
sudo nixos-rebuild switch --flake .#typhon

# Build only (no activation)
sudo nixos-rebuild build --flake .#hydra
sudo nixos-rebuild build --flake .#griffin
sudo nixos-rebuild build --flake .#typhon

# Direct derivation build per host
nix build .#nixosConfigurations.hydra.config.system.build.toplevel
nix build .#nixosConfigurations.griffin.config.system.build.toplevel
nix build .#nixosConfigurations.typhon.config.system.build.toplevel

# VM build for safer validation
nix build .#nixosConfigurations.hydra.config.system.build.vm
```

## Home Manager Commands

```bash
# Standalone Home Manager apply
home-manager switch --flake .#edubarr

# Standalone HM build
nix build .#homeConfigurations.edubarr.activationPackage
```

Notes:

- Rebuilding `griffin` or `typhon` also applies Home Manager.
- Rebuilding `hydra` does not apply Home Manager.

## Lint And Formatting

This flake does not pin lint/format checks. Use ephemeral tools.

```bash
# Format check (no write)
nix run nixpkgs#alejandra -- --check .

# Format write
nix run nixpkgs#alejandra -- .

# Lint Nix anti-patterns
nix run nixpkgs#statix -- check .

# Detect unused declarations
nix run nixpkgs#deadnix -- .
```

## Test/Validation Commands

```bash
# Full flake checks (preferred baseline)
nix flake check --print-build-logs

# Show available outputs/checks
nix flake show

# Parse one Nix file (syntax-only)
nix-instantiate --parse hosts/griffin/modules/nvidia.nix

# Evaluate one option value
nix eval .#nixosConfigurations.typhon.config.programs.hyprland.enable
```

## Running A Single Test (Priority)

Preferred single-check workflow:

```bash
# 1) discover checks
nix flake show

# 2) run one check only
nix build .#checks.x86_64-linux.<checkName>
```

If `checks` are not exposed, use single-target fallbacks:

- Single host test: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
- Single HM test: `nix build .#homeConfigurations.edubarr.activationPackage`
- Single file syntax test: `nix-instantiate --parse path/to/file.nix`
- Single option eval test: `nix eval .#nixosConfigurations.<host>.config.<path.to.option>`

## Update Commands

```bash
# Update all flake inputs
nix flake update

# Update one input
nix flake lock --update-input nixpkgs
```

## Code Style Guidelines

### Imports And File Placement

- Use relative imports.
- Keep imports one entry per line.
- Keep import lists alphabetized unless ordering is semantically required.
- Shared behavior belongs in `modules/`.
- Host-specific behavior belongs in `hosts/<host>/modules/`.
- Add new module files to the corresponding `default.nix` aggregator.

### Formatting

- Use 2-space indentation; do not use tabs.
- End assignments with `;`.
- Keep opening braces on the same line as module lambda/expression.
- Keep logical sections separated by blank lines.
- Prefer multi-line lists/attrsets once entries grow.

### Types, Signatures, And Values

- Typical module signatures: `{ ... }:` or `{ pkgs, config, ... }:`.
- Keep `...` for forward compatibility unless restrictions are intentional.
- Match option types strictly:
  - booleans for toggles
  - integers for ports
  - strings for hostnames/paths/domains
  - lists for repeated values
- Use `toString` when interpolating non-strings into strings.

### Naming Conventions

- File names: kebab-case (`file-systems.nix`, `local-packages.nix`).
- Variables/functions: camelCase (`homeStateVersion`, `makeVirtualHost`).
- Host/user identifiers: lowercase (`hydra`, `griffin`, `typhon`, `edubarr`).
- Systemd units: descriptive names (`tailscale-autoconnect`).

### Package And Script Usage

- Prefer explicit binary paths in scripts:
  - `${pkgs.iproute2}/bin/ip`
  - `${pkgs.ethtool}/bin/ethtool`
- Avoid broad `with pkgs;` at module scope.
- Local/narrow `with pkgs;` usage is acceptable in short script blocks.

### Error Handling And Reliability

- Use `after`/`wants` to model startup ordering where needed.
- Use `Type = "oneshot"` only for actual one-shot jobs.
- Add restart policy for long-running services (for example `Restart = "on-failure"`).
- In shell snippets, prefer strict mode (`set -euo pipefail`) when compatible.
- Avoid silent failure paths; keep command execution explicit.

### Security And Secrets

- Never commit secrets, tokens, credentials, or private keys.
- Keep runtime secret files under `/var/lib/...` outside git.
- Use `environmentFile`/`credentialsFile` for secret injection.
- Do not hardcode new plaintext passwords.

### Comments

- Keep comments concise and intent-focused.
- Prefer explaining why, not obvious syntax.
- Remove stale comments during related edits.

## Agent Workflow Checklist

1. Make minimal, scoped changes.
2. Preserve shared vs host-specific boundaries.
3. Run format/lint checks when available.
4. Run at least one validation command (`nix flake check` preferred).
5. For risky storage/network changes, prefer VM build before live switch.
6. If `nix` is unavailable, report exactly which checks were not runnable.
