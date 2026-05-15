#!/usr/bin/env bash
set -euo pipefail

# Installs a K3s server on the current machine (run on the first node only).
# After install, fetch the join token with:
#   sudo cat /var/lib/rancher/k3s/server/node-token

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -

echo "K3s server installed. Verify with: sudo k3s kubectl get nodes"
