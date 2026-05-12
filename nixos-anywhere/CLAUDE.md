# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Personal NixOS configuration flake for reproducible system deployments. Supports two workflows: building a bootable USB ISO and deploying remotely via `nixos-anywhere`.

## Key Commands

**Build the installer ISO:**
```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
# Output: result/iso/ — flash to USB with dd or similar
```

**Deploy to a target machine (boots from the ISO first):**
```bash
nixos-anywhere --flake .#generic \
  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
  root@<target-ip>
```

**Check the flake for errors:**
```bash
nix flake check
```

**Test a config builds without deploying:**
```bash
nix build .#nixosConfigurations.generic.config.system.build.toplevel
```

## Flake Outputs

| Name | Purpose |
|---|---|
| `iso` | Bootable live environment for initial installs |
| `generic` | Primary install target with disko disk partitioning |
| `recovery` | Alternative partition layout for recovery scenarios |
| `generic-nixos-facter` | Experimental variant using nixos-facter for hardware detection |

## Architecture

**Module hierarchy for the installed system (`generic`):**
- `initialconfiguration.nix` — Top-level: boot, SSH (root login enabled), NetworkManager, user account
  - `disk-config.nix` — Disko GPT layout: EFI partition → LVM pool VG → root + home LVs
  - `network.nix` — NetworkManager with Wi-Fi preset support (generates `.nmconnection` files)
  - `hardware-configuration.nix` — Auto-generated per machine during nixos-anywhere deployment

**ISO live environment (`iso`):**
- `iso.nix` — SSH keys, installer tooling, partitioning helpers
  - `network.nix` — Same network module reused

**Personal laptop config (`configuration.nix`, not used by `generic`):**
- `configuration.nix` — Boot (hibernation, swap file), firewall (nftables), Bluetooth, PipeWire
  - `programs.nix` — 60+ packages, Tailscale, ZeroTier, Flatpak, Catppuccin theme
  - `starship.nix` — Zsh + Starship prompt with git integration
  - `laptop.nix` — Laptop-specific additions (batsignal)

**Cloud deployment:**
- `digitalocean.nix` — DigitalOcean target with cloud-init integration

## Key Design Decisions

- **Disko** manages all disk partitioning declaratively — never manually partition on deployment targets.
- `hardware-configuration.nix` is intentionally a template/placeholder; it gets overwritten with `--generate-hardware-config` on each new machine.
- `network.nix` is shared between the ISO and installed system to keep Wi-Fi presets consistent across both environments.
- SSH root login is enabled on `initialconfiguration.nix` intentionally — required for `nixos-anywhere` to connect during deployment.
- The README warns that SSH keys and Wi-Fi PSKs in `iso.nix` / `network.nix` must be replaced before sharing or publishing this repo.
