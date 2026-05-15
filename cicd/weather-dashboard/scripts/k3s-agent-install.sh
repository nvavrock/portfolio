#!/usr/bin/env bash
set -euo pipefail

# Installs a K3s agent. Required environment variables:
#   K3S_URL   (example: https://10.0.0.5:6443)
#   K3S_TOKEN (from /var/lib/rancher/k3s/server/node-token on the server)

if [[ -z "${K3S_URL:-}" || -z "${K3S_TOKEN:-}" ]]; then
  echo "Set K3S_URL and K3S_TOKEN before running this script." >&2
  exit 1
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -

echo "K3s agent installed. Verify on the server with: sudo k3s kubectl get nodes"
