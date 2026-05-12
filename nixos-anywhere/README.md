# nixos-anywhere flake

This repository is a [Nix flake](flake.nix) with two complementary pieces:

1. **Live USB image (`iso.nix`)** — Build bootable installation media you flash to a drive. It is a minimal NixOS installer CD plus local customizations (SSH, user, NetworkManager, extra tools, and Wi‑Fi helper options wired through [`network.nix`](network.nix)).
2. **Installed system (`initialconfiguration.nix`)** — The configuration you deploy to the machine **after** it boots the live environment. Uses [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) against a per-hostname output. Pulls in [disko](https://github.com/nix-community/disko) layout from [`disk-config.nix`](disk-config.nix), boot loaders, OpenSSH, your user, and [sops-nix](https://github.com/Mic92/sops-nix) for secret management.

Boot from the USB, get on the network (Ethernet or the Wi‑Fi setup you define), then run `deploy.sh` to partition, format, install NixOS, and apply your real dotfiles config in one shot.

## Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs` | NixOS unstable channel |
| `disko` | Declarative disk partitioning |
| `sops-nix` | Secret management via age/GPG |
| `nixos-facter-modules` | Experimental hardware detection alternative |

## Outputs (NixOS configurations)

| Attribute | Purpose |
|-----------|---------|
| `nixosConfigurations.<hostname>` | **Auto-generated** from files in [`hostnameconfig/`](hostnameconfig/) — one per machine. Created by `deploy.sh`. |
| `nixosConfigurations.iso` | Minimal install CD + [`iso.nix`](iso.nix) — use this to **build the flashable ISO**. |
| `nixosConfigurations.generic` | Legacy fallback with no hostname set. Use when you haven't created a hostnameconfig entry yet. |
| `nixosConfigurations.recovery` | Alternate layout using `configurationrecover.nix`; for recovery-style installs. |
| `nixosConfigurations.generic-nixos-facter` | Experimental: like generic but uses nixos-facter instead of `nixos-generate-config`. |

## Prerequisites

Before running any deployment:

- `secrets/secrets.yaml` must exist and be sops-encrypted with your age key.
- `~/.config/sops/age/keys.txt` must contain your age private key.
- `nixos-anywhere` must be on `PATH` (`nix shell github:nix-community/nixos-anywhere`).

To generate an age key if you don't have one:

```bash
age-keygen -o ~/.config/sops/age/keys.txt
```

## Build the USB image

From the repository root:

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

The result is under `result/iso/`. Write it to a USB drive with your usual tool (`dd`, `cp` to the raw device, [Fedora Media Writer](https://github.com/FedoraQt/MediaWriter), etc.), then boot the target machine from that medium.

On the live system, ensure SSH keys in [`iso.nix`](iso.nix) match the machine you connect from.

## Deploy a new machine (recommended)

`deploy.sh` is the primary deployment script. It runs a two-phase process:

1. **Bootstrap phase** — runs `nixos-anywhere` to partition, format, and install the base NixOS config (from this flake). Injects your age key so sops-nix can decrypt secrets on boot.
2. **Dotfiles phase** — SSHes into the freshly booted machine, clones your dotfiles bare repo, places the hardware/disk configs, patches the dotfiles flake to add the new hostname, and runs `nixos-rebuild switch` to apply your real configuration.

```bash
./deploy.sh <target-ip> <hostname>
# Example: ./deploy.sh 192.168.1.50 kerrigan
```

Options:

- `--skip-nixos-anywhere` — Skip phase 1 (bootstrap) and go straight to the dotfiles phase. Useful if the machine already has NixOS installed.

`deploy.sh` will auto-create `hostnameconfig/<hostname>.nix` if it doesn't already exist. That file sets `networking.hostName` and gets picked up by the flake automatically.

### deploy2.sh variant

`deploy2.sh` is identical to `deploy.sh` but runs the dotfiles phase as a detached `systemd` unit (`nixos-apply`) instead of an interactive SSH session. This lets you Ctrl-C from the log tail without aborting the setup — the job keeps running on the target.

```bash
./deploy2.sh <target-ip> <hostname>
# Follow logs (safe to Ctrl-C): journalctl -u nixos-apply on target
```

## Manual nixos-anywhere (without deploy.sh)

If you want to run nixos-anywhere directly without the dotfiles phase:

```bash
nixos-anywhere --flake .#<hostname> \
  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
  root@<target-ip>
```

For the facter-based experimental configuration:

```bash
nixos-anywhere --flake .#generic-nixos-facter \
  --generate-hardware-config nixos-facter ./facter.json \
  root@<target-ip>
```

## Per-hostname configs

The flake auto-generates a `nixosConfiguration` for every `.nix` file found in [`hostnameconfig/`](hostnameconfig/). Each file is minimal — typically just:

```nix
{ networking.hostName = "kerrigan"; }
```

All share the same `bootstrapModules` (disko, sops-nix, `initialconfiguration.nix`, `hardware-configuration.nix`). The `deploy.sh` script creates these files automatically.

## What each module adds

- **[`iso.nix`](iso.nix)** — Live environment: user and root SSH keys, OpenSSH, NetworkManager, `networkPresets.wifiNetworks` (see [`network.nix`](network.nix)), installer tooling.
- **[`initialconfiguration.nix`](initialconfiguration.nix)** — Installed system base: imports disk layout, network profile, systemd-boot + EFI, OpenSSH (root login enabled for nixos-anywhere), NetworkManager, user account and groups, sops-nix age key path.
- **[`disk-config.nix`](disk-config.nix)** — Disko GPT layout: EFI partition → LVM pool → root + home logical volumes.
- **[`network.nix`](network.nix)** — NetworkManager with Wi-Fi preset support. Shared between ISO and installed system.

## Secrets

Secrets are managed with [sops-nix](https://github.com/Mic92/sops-nix). The encrypted file lives at `secrets/secrets.yaml`. The age private key is injected into the target at `/var/lib/sops-nix/age-key.txt` during deployment via `--extra-files`.

Before sharing or publishing the repo, replace placeholder secrets (Wi-Fi PSKs, SSH public keys) in `iso.nix`, `initialconfiguration.nix`, and related files with your own values. Do **not** commit unencrypted secrets.
