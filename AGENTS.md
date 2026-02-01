# AGENTS.md - NixOS Configuration Repository

NixOS system and Home Manager configurations using Nix Flakes for a home server named "hydra".

## Project Structure

```
├── flake.nix                 # Main flake entry point
├── flake.lock                # Pinned dependencies
├── home-manager/home.nix     # User home configuration
├── hosts/hydra/
│   ├── configuration.nix     # Main host config
│   ├── hardware-configuration.nix
│   └── modules/              # Host-specific modules
└── modules/                  # Shared/common modules
```

## Build Commands

```bash
# Build and switch to new system configuration
sudo nixos-rebuild switch --flake .#hydra

# Build without switching (for testing)
sudo nixos-rebuild build --flake .#hydra

# Home Manager - switch to new configuration
home-manager switch --flake .#edubarr

# Validate flake structure
nix flake check

# Show flake outputs
nix flake show

# Check syntax of a single file
nix-instantiate --parse path/to/file.nix

# Update all flake inputs
nix flake update

# Update a specific input
nix flake lock --update-input nixpkgs
```

## Code Style Guidelines

### File Organization
- **Host-specific**: `hosts/<hostname>/modules/<feature>.nix`
- **Shared**: `modules/<feature>.nix`
- **Aggregators**: Use `default.nix` to import sibling modules

### Formatting
- 2-space indentation (no tabs)
- Opening brace on same line as expression
- Semicolons at end of attribute assignments

### Module Pattern
```nix
# Without arguments:
{ services.example.enable = true; }

# With arguments:
{ pkgs, config, ... }:
{ environment.systemPackages = [ pkgs.example ]; }
```

### Attribute Sets and Lists
```nix
# Short - one line
{ enable = true; port = 8080; }
[ "item1" "item2" ]

# Long - line breaks
{
  enable = true;
  settings = { port = 8080; };
}
```

### Imports
```nix
{ imports = [ ./bluetooth.nix ./docker.nix ./network.nix ]; }
```
Use relative paths, list alphabetically when practical.

### Naming Conventions
- File names: kebab-case (`file-systems.nix`)
- Variables: camelCase (`homeStateVersion`, `makeSystem`)

### String Interpolation
```nix
"Hello ${name}"
script = ''
  ${pkgs.coreutils}/bin/ls -la
'';
```

### Package References
- Always use full paths: `${pkgs.docker-compose}/bin/docker-compose`
- Use `with pkgs;` sparingly

### Error Handling
- Use `nofail` for non-critical mounts
- Use `after` and `wants` for service dependencies
- Use `Restart = "on-failure"` for auto-recovery

### Secrets
- Store in `/var/lib/<service>/` outside repo
- Reference via `environmentFile` or `credentialsFile`
- Never commit credentials

## Adding Configuration

### New Host Module
1. Create `hosts/hydra/modules/<feature>.nix`
2. Add to `hosts/hydra/modules/default.nix`

### New Shared Module
1. Create `modules/<feature>.nix`
2. Add to `modules/default.nix`

### New Host
1. Create `hosts/<hostname>/configuration.nix`
2. Create `hosts/<hostname>/hardware-configuration.nix`
3. Add entry to `hosts` in `flake.nix`

## Common Patterns

### Systemd Services
```nix
systemd.services.my-service = {
  description = "Description";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "${pkgs.example}/bin/command";
  };
};
```

### Firewall Rules
```nix
networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 22 80 443 ];
  trustedInterfaces = [ "tailscale0" ];
};
```

## Environment
- NixOS: 25.05 (unstable)
- System: x86_64-linux
- Inputs: nixpkgs (nixos-unstable), home-manager (follows nixpkgs)
