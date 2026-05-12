#!/usr/bin/env bash
# deploy2.sh — bootstrap a new machine then apply the real NixOS config from dotfiles.
#
# Usage: ./deploy2.sh <target-ip> <hostname>
#   target-ip    IP of the target (must be booted from the installer ISO)
#   hostname     The new machine's hostname (e.g. terra, luna)
#                Creates hostnameconfig/<hostname>.nix if it doesn't exist.
#
# Prerequisites:
#   - secrets/secrets.yaml exists and is sops-encrypted
#   - ~/.config/sops/age/keys.txt contains your age private key
#   - nixos-anywhere is on PATH (nix shell github:nix-community/nixos-anywhere)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_REPO="https://github.com/violetbp/dotfiles.git"
DOTFILES_USER="vboysepe"
AGE_KEY_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/sops/age/keys.txt"

SKIP_NIXOS_ANYWHERE=0
if [[ "${1:-}" == "--skip-nixos-anywhere" ]]; then
  SKIP_NIXOS_ANYWHERE=1
  shift
fi

TARGET_IP="${1:-}"
HOSTNAME="${2:-}"

[[ -z "$TARGET_IP" ]] && read -rp "Target IP: " TARGET_IP
[[ -z "$HOSTNAME"  ]] && read -rp "Hostname: " HOSTNAME

# Validate prerequisites
if [[ ! -f "$AGE_KEY_FILE" ]]; then
  echo "ERROR: age key not found at $AGE_KEY_FILE"
  echo "  Run: age-keygen -o $AGE_KEY_FILE"
  exit 1
fi

if [[ ! -f "$SCRIPT_DIR/secrets/secrets.yaml" ]]; then
  echo "ERROR: secrets/secrets.yaml not found."
  echo "  Run: cp secrets/secrets.yaml.example secrets/secrets.yaml && sops -e -i secrets/secrets.yaml"
  exit 1
fi

# Create hostnameconfig/<hostname>.nix if it doesn't already exist.
HOSTNAME_NIX="$SCRIPT_DIR/hostnameconfig/${HOSTNAME}.nix"
if [[ ! -f "$HOSTNAME_NIX" ]]; then
  echo "==> Creating $HOSTNAME_NIX"
  mkdir -p "$SCRIPT_DIR/hostnameconfig"
  printf '{ networking.hostName = "%s"; }\n' "$HOSTNAME" > "$HOSTNAME_NIX"
fi

# Inject the age key into a temp dir for nixos-anywhere --extra-files.
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
install -Dm600 "$AGE_KEY_FILE" "$TMP/var/lib/sops-nix/age-key.txt"

if [[ "$SKIP_NIXOS_ANYWHERE" -eq 0 ]]; then
  echo "==> Bootstrapping $HOSTNAME onto $TARGET_IP..."
  nixos-anywhere \
    --flake "$SCRIPT_DIR#${HOSTNAME}" \
    --generate-hardware-config nixos-generate-config "$SCRIPT_DIR/hardware-configuration.nix" \
    --extra-files "$TMP" \
    root@"${TARGET_IP}"

  echo "==> Waiting for machine to come back up..."
  until ssh \
      -o StrictHostKeyChecking=no \
      -o ConnectTimeout=5 \
      -o BatchMode=yes \
      root@"${TARGET_IP}" true 2>/dev/null; do
    printf '.'
    sleep 5
  done
  echo
else
  echo "==> Skipping nixos-anywhere deployment (--skip-nixos-anywhere)."
fi

# --- Local dotfiles edits ---
LOCAL_NIXOS="$HOME/.config/nixos"
LOCAL_GIT="git --git-dir=$HOME/.cfg --work-tree=$HOME"

echo "==> Updating local dotfiles config for $HOSTNAME..."

# Copy hardware config into dotfiles repo
mkdir -p "$LOCAL_NIXOS/hardwareConfig"
cp "$SCRIPT_DIR/hardware-configuration.nix" "$LOCAL_NIXOS/hardwareConfig/${HOSTNAME}-hw.nix"

# Copy disk config into dotfiles repo
cp "$SCRIPT_DIR/disk-config.nix" "$LOCAL_NIXOS/hostnameConfig/${HOSTNAME}-disk.nix"

# Create the hostname config wrapper if not already present
HOST_CONFIG="$LOCAL_NIXOS/hostnameConfig/${HOSTNAME}-config.nix"
if [[ ! -f "$HOST_CONFIG" ]]; then
  cat > "$HOST_CONFIG" << EOF
{ ... }:
{
  imports = [
    ../hardwareConfig/${HOSTNAME}-hw.nix
    ./${HOSTNAME}-disk.nix
  ];

  networking.hostName = "${HOSTNAME}";
  system.stateVersion = "25.11";
}
EOF
fi

# Add hostname to flake.nix if not present
FLAKE="$LOCAL_NIXOS/flake.nix"
if ! grep -q "${HOSTNAME} =" "$FLAKE" 2>/dev/null; then
  awk '
/nixosConfigurations\s*=\s*\{/ { inConfigs=1 }
inConfigs && /^    };/ && !done {
  print "      '"${HOSTNAME}"' = nixpkgs.lib.nixosSystem {"
  print "        system = \"x86_64-linux\";"
  print "        specialArgs = { inherit inputs; };"
  print "        modules = ["
  print "          inputs.disko.nixosModules.disko"
  print "          ./hostnameConfig/'"${HOSTNAME}"'-config.nix"
  print "          ./configuration.nix"
  print "        ];"
  print "      };"
  done=1
}
{ print }
' "$FLAKE" > /tmp/flake.tmp && mv /tmp/flake.tmp "$FLAKE"
fi

# Commit and push via local bare repo
echo "==> Committing and pushing dotfiles..."
$LOCAL_GIT add \
  "$LOCAL_NIXOS/hardwareConfig/${HOSTNAME}-hw.nix" \
  "$LOCAL_NIXOS/hostnameConfig/${HOSTNAME}-disk.nix" \
  "$LOCAL_NIXOS/hostnameConfig/${HOSTNAME}-config.nix" \
  "$LOCAL_NIXOS/flake.nix"
$LOCAL_GIT commit -m "deploy: add ${HOSTNAME} nixos config"
$LOCAL_GIT push

# --- Target-side apply ---
echo "==> Writing setup script to ${TARGET_IP}..."
ssh -o StrictHostKeyChecking=no root@"${TARGET_IP}" 'cat > /tmp/nixos-setup.sh && chmod +x /tmp/nixos-setup.sh' << ENDSSH
#!/usr/bin/env bash
set -e
export PATH=/run/current-system/sw/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Clone dotfiles bare repo using HTTPS (no SSH key needed for public repo)
git clone --bare ${DOTFILES_REPO} /home/${DOTFILES_USER}/.cfg

# Back up any files that would conflict with checkout, then check out
conflicts=\$(git --git-dir=/home/${DOTFILES_USER}/.cfg --work-tree=/home/${DOTFILES_USER} checkout 2>&1 \
  | grep -E '^\s+' | awk '{print \$1}' || true)
if [[ -n "\$conflicts" ]]; then
  echo "\$conflicts" | while read -r f; do
    mkdir -p "/home/${DOTFILES_USER}/.cfg-backup/\$(dirname "\$f")"
    mv "/home/${DOTFILES_USER}/\$f" "/home/${DOTFILES_USER}/.cfg-backup/\$f"
  done
  git --git-dir=/home/${DOTFILES_USER}/.cfg --work-tree=/home/${DOTFILES_USER} checkout
fi
git --git-dir=/home/${DOTFILES_USER}/.cfg --work-tree=/home/${DOTFILES_USER} \
  config --local status.showUntrackedFiles no

chown -R ${DOTFILES_USER}:users /home/${DOTFILES_USER}

# Switch to the real NixOS configuration
nixos-rebuild switch --flake /home/${DOTFILES_USER}/.config/nixos#${HOSTNAME}

echo "==> Setup complete."
ENDSSH

echo "==> Launching setup on ${TARGET_IP} (detached)..."
ssh -o StrictHostKeyChecking=no root@"${TARGET_IP}" \
  'systemd-run --unit=nixos-apply --no-block bash /tmp/nixos-setup.sh'

echo "==> Following logs (Ctrl-C is safe — setup continues on target)..."
ssh -o StrictHostKeyChecking=no root@"${TARGET_IP}" '
  journalctl -u nixos-apply -f --no-pager &
  JPID=$!
  while [[ "$(systemctl is-active nixos-apply 2>/dev/null)" =~ ^(active|activating)$ ]]; do
    sleep 2
  done
  sleep 3
  kill $JPID 2>/dev/null
  wait $JPID 2>/dev/null
  systemctl show nixos-apply --property=Result --value 2>/dev/null || echo unknown
' || true
echo

RESULT=$(ssh -o StrictHostKeyChecking=no root@"${TARGET_IP}" \
  'systemctl show nixos-apply --property=Result --value 2>/dev/null || echo unknown')

if [[ "$RESULT" == "success" ]]; then
  echo "==> Done. $HOSTNAME is running its real config."
  echo "    SSH in: ssh ${DOTFILES_USER}@${TARGET_IP}"
else
  echo "ERROR: nixos-apply finished with result: $RESULT"
  echo "  Check logs: ssh root@${TARGET_IP} 'journalctl -u nixos-apply'"
  exit 1
fi
