#!/usr/bin/env bash
# =============================================================================
# K3s AGENT install — run on the SECOND cloud VM (worker node)
# =============================================================================
# The agent registers with the server and runs workloads (pods). You must set
# two environment variables BEFORE running this script:
#
#   export K3S_URL="https://<SERVER_PRIVATE_IP>:6443"
#   export K3S_TOKEN="<paste token from server node>"
#
# Use the server's PRIVATE IP (terraform output k3s_private_ipv4[0]) so cluster
# traffic stays inside the VCN, not over the public internet.
# =============================================================================

set -euo pipefail

if [[ -z "${K3S_URL:-}" || -z "${K3S_TOKEN:-}" ]]; then
  echo "Set K3S_URL and K3S_TOKEN before running this script." >&2
  exit 1
fi

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -
# Same installer as server, but agent mode — joins existing cluster instead of creating one.

echo "K3s agent installed. Verify on the server with: sudo k3s kubectl get nodes"
