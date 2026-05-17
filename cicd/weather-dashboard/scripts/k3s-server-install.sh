#!/usr/bin/env bash
# =============================================================================
# K3s SERVER install — run on the FIRST cloud VM only (control plane node)
# =============================================================================
# K3s is a lightweight Kubernetes distribution. The "server" node runs the API,
# scheduler, and etcd (cluster brain). Workers (agents) join using a token.
#
# Usage (after SSH to terraform output k3s_public_ipv4[0]):
#   bash k3s-server-install.sh
#
# After install, get the join token for the second node:
#   sudo cat /var/lib/rancher/k3s/server/node-token
# =============================================================================

set -euo pipefail
# -e = exit on error, -u = error on unset variables, -o pipefail = fail pipelines on error.

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -
# Downloads Rancher's installer and starts K3s in server mode.
# --write-kubeconfig-mode 644 = kubeconfig readable so you can copy it for kubectl.

echo "K3s server installed. Verify with: sudo k3s kubectl get nodes"
