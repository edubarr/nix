# Agentic Coding Guidelines for NixOS Configuration

This repository contains a NixOS configuration managed with Nix Flakes. It defines system configurations for hosts (e.g., `hydra`) and Home Manager configurations.

## 1. Build, Lint, and Test Commands

Since this is a declarative NixOS configuration, "building" implies realizing the system configuration.

### Build & Verify
To verify that the configuration builds correctly without applying it (Dry Run):
```bash
# Verify the 'hydra' host configuration
nix build .#nixosConfigurations.hydra.config.system.build.toplevel --dry-run
```

To build the configuration (results in `./result` link):
```bash
nix build .#nixosConfigurations.hydra.config.system.build.toplevel
```

### Apply Configuration (If running on NixOS)
```bash
# Apply configuration to the current system (if hostname matches 'hydra')
sudo nixos-rebuild switch --flake .#hydra
```

### Linting & Formatting
There is no strict linter enforced by CI visible, but adhere to standard Nix formatting.
- **Format**: Use 2 spaces for indentation.
- **Check Syntax**: `nix instantiate --parse ./path/to/file.nix`

### Dependency Management
- **Update Lockfile**: `nix flake update` (Updates `flake.lock`)
- **Check Flake**: `nix flake check` (Verifies flake outputs validity)

## 2. Code Style & Structure

### Project Structure
- `flake.nix`: Entry point. Defines inputs (nixpkgs, home-manager) and outputs (nixosConfigurations).
- `hosts/<hostname>/`: Host-specific configurations.
  - `configuration.nix`: Main system config for the host.
  - `hardware-configuration.nix`: Hardware scan (do not edit manually unless necessary).
  - `modules/`: Host-specific modules.
- `modules/`: Shared NixOS modules usable by any host.
- `home-manager/`: Home Manager user configurations.

### Nix Language Conventions
- **Indentation**: ALWAYS use **2 spaces**. Do not use tabs.
- **Naming**:
  - **Files**: kebab-case (e.g., `garbage-collector.nix`, `system-services.nix`).
  - **Attributes**: camelCase (e.g., `extraSpecialArgs`, `homeStateVersion`).
- **Imports**:
  - Use relative paths: `imports = [ ./module.nix ../../shared.nix ];`
  - Group imports at the top of the file.

### Module Pattern
Most files in `modules/` are simple attribute sets or functions returning attribute sets.

**Simple Module (Attribute Set):**
```nix
{
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}
```

**Function Module (Argument Pattern):**
If you need access to `pkgs`, `config`, or `lib`:
```nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vim git ];
}
```

### Flake Inputs
- Defined in `flake.nix`.
- Access inputs in modules via `specialArgs` (NixOS) or `extraSpecialArgs` (Home Manager).
- Example: `inputs.nixpkgs` or `inputs.home-manager`.

## 3. Implementation Rules for Agents

### Modifying Configuration
1.  **Analyze Context**: Before adding a service/package, check `modules/` or `hosts/<host>/modules/` to see if a similar module exists.
2.  **Do Not Duplicate**: If a feature (e.g., Docker) is already defined in a shared module, reuse it or enhance it rather than creating a duplicate in `configuration.nix`.
3.  **Packages**:
    - Add system-wide packages to `environment.systemPackages`.
    - Add user-specific packages in `home-manager/home.nix` or strict user modules.
    - Use `pkgs.<package_name>` (e.g., `pkgs.git`).
    - Verify package names using `nix search nixpkgs <name>` or checking search.nixos.org if possible (or assume standard nixpkgs names).

### Editing `flake.nix`
- **Caution**: `flake.nix` is the core. Avoid changing `inputs` unless requested (e.g., upgrading nixpkgs version).
- **New Hosts**: To add a new host, add a new entry in the `hosts` list variable or the `nixosConfigurations` output.

### Error Handling
- Nix is lazy. Errors often appear only at build time.
- If a value is optional, use `lib.mkOption` with `default` if writing a complex module, or simply `lib.mkIf` to guard configurations.
- Ensure all opening braces `{` and lists `[` are properly closed.

### Safety
- **Secrets**: Do NOT commit actual secrets (passwords, private keys) to git. Use `sops-nix` or `git-crypt` if implemented, or place headers reminding to use environment variables/separate files.
- **State Version**: Do NOT change `system.stateVersion` or `home.stateVersion` unless you are performing a major state upgrade and understand the implications (it affects data storage paths).

## 4. Common Tasks

**Adding a Package:**
Find the relevant `system-services.nix`, `local-packages.nix`, or `home.nix`.
```nix
environment.systemPackages = with pkgs; [
  ripgrep
  bat
];
```

**Adding a Service:**
Create a new file in `modules/` (e.g., `modules/monitoring.nix`) and import it in the host's configuration.

```nix
# modules/monitoring.nix
{ config, pkgs, ... }:
{
  services.grafana.enable = true;
}
```

**Refactoring:**
Move inline configuration from `hosts/<host>/configuration.nix` to a dedicated file in `hosts/<host>/modules/` or `modules/` if it can be shared.
