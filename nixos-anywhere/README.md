# nixos-anywhere flake

This repository is a [Nix flake](flake.nix) with two complementary pieces:

1. **Live USB image (`iso.nix`)** — Build bootable installation media you flash to a drive. It is a minimal NixOS installer CD plus local customizations (SSH, user, NetworkManager, extra tools, and Wi‑Fi helper options wired through [`network.nix`](network.nix)).
2. **Installed system (`initialconfiguration.nix`)** — The configuration you deploy to the machine **after** it boots the live environment, using [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) against the `generic` output. It pulls in [disko](https://github.com/nix-community/disko) layout from [`disk-config.nix`](disk-config.nix), boot loaders, OpenSSH, your user, and related settings.

Boot from the USB, get on the network (Ethernet or the Wi‑Fi setup you define), then run `nixos-anywhere` from this flake to partition, format, and install NixOS on the target disks.

## Inputs

The flake follows `nixpkgs` (unstable), pulls in **disko**, and optionally **nixos-facter-modules** for an experimental hardware path (see below).

## Outputs (NixOS configurations)

| Attribute | Purpose |
|-----------|---------|
| `nixosConfigurations.iso` | Minimal install CD + [`iso.nix`](iso.nix) — use this to **build the flashable ISO**. |
| `nixosConfigurations.generic` | **Default install target** — disko + [`initialconfiguration.nix`](initialconfiguration.nix) + `hardware-configuration.nix`. Use with nixos-anywhere on the live-booted machine. |
| `nixosConfigurations.recovery` | Alternate layout using `configurationrecover.nix` (no disko in flake snippet); for recovery-style installs. |
| `nixosConfigurations.generic-nixos-facter` | Experimental: like generic but uses nixos-facter instead of `nixos-generate-config` (see comment in [`flake.nix`](flake.nix)). |

## Build the USB image

From the repository root:

```bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
```

The result is under `result/iso/`. Write it to a USB drive with your usual tool (`dd`, `cp` to the raw device, [Fedora Media Writer](https://github.com/FedoraQt/MediaWriter), etc.), then boot the target machine from that medium.

On the live system, set passwords as needed (`passwd` for your user if you use password auth) and ensure SSH keys in [`iso.nix`](iso.nix) match the machine you connect from.

## Install to the live-booted machine (nixos-anywhere)

On a host with this flake and nixos-anywhere available:

1. Ensure [`hardware-configuration.nix`](hardware-configuration.nix) exists (generate it on first install if you do not have it yet).
2. Adjust [`disk-config.nix`](disk-config.nix), [`network.nix`](network.nix), and [`initialconfiguration.nix`](initialconfiguration.nix) for the target hardware and network before running install.
3. Run nixos-anywhere against `generic`, for example:

```bash
nixos-anywhere --flake .#generic \
  --generate-hardware-config nixos-generate-config ./hardware-configuration.nix \
  <hostname-or-ip>
```

For the facter-based experimental configuration, the flake comment suggests:

```bash
nixos-anywhere --flake .#generic-nixos-facter \
  --generate-hardware-config nixos-facter ./facter.json \
  <hostname-or-ip>
```

Replace `<hostname-or-ip>` with the address of the machine running the live ISO (reachable over SSH).

## What each module adds

- **[`iso.nix`](iso.nix)** — Defines the live environment: user and root SSH keys, OpenSSH, NetworkManager, `networkPresets.wifiNetworks` (see [`network.nix`](network.nix)), installer tooling (`nixos-install`, partitioning helpers, editors, etc.). Intended only for the **ISO** output in [`flake.nix`](flake.nix).
- **[`initialconfiguration.nix`](initialconfiguration.nix)** — Defines the **installed** system: imports disk layout, network profile, systemd-boot + EFI, OpenSSH (including root login settings), NetworkManager, user account and groups, low-priority `curl`/`git`, and `system.stateVersion`. Used by `nixosConfigurations.generic` together with `hardware-configuration.nix`.

Before sharing or publishing the repo, replace placeholder secrets (Wi‑Fi PSKs, SSH public keys) in `iso.nix`, `initialconfiguration.nix`, and related files with your own values.
