# K3s bootstrap (two-node cluster)

## In plain terms

**Terraform** created two empty Linux servers in Oracle Cloud. **K3s** turns them into a small **Kubernetes cluster**:

- **Node 0 (server)** = the boss — stores cluster state, API, scheduling.
- **Node 1 (agent)** = a worker — runs your app pods.

After this guide, `kubectl` on your laptop can talk to the cluster. Then you apply `k8s/` to run the weather dashboard.

**Order of operations:** Terraform → this bootstrap → `kubectl apply -k k8s/` → observability (optional).

---

These steps match the Terraform layout: **two Ubuntu ARM instances** in the same VCN/security lists as [`../terraform/`](../terraform/).

## 1) Install the K3s server (node 0)

SSH to the first public IP from `terraform output`:

```bash
ssh ubuntu@<k3s_public_ipv4[0]>
```

On the server:

```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --write-kubeconfig-mode 644" sh -
sudo k3s kubectl get nodes
```

Or run the helper script copied to the server: `bash k3s-server-install.sh`

Copy the **node token** (needed for the agent):

```bash
sudo cat /var/lib/rancher/k3s/server/node-token
```

## 2) Install the K3s agent (node 1)

SSH to the second node:

```bash
ssh ubuntu@<k3s_public_ipv4[1]>
```

Run (replace placeholders):

```bash
export K3S_URL="https://<SERVER_PRIVATE_IP>:6443"
export K3S_TOKEN="<NODE_TOKEN_FROM_SERVER>"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent" sh -
```

Or use `k3s-agent-install.sh` after exporting `K3S_URL` and `K3S_TOKEN`.

Use the **server private IP** (`k3s_private_ipv4[0]`) for `K3S_URL` so traffic stays inside the VCN.

## 3) kubeconfig from your laptop

Copy `/etc/rancher/k3s/k3s.yaml` from the server and replace `127.0.0.1` with the **server public IP** (or set up a DNS name / load balancer later).

```bash
scp ubuntu@<server_public_ip>:/etc/rancher/k3s/k3s.yaml ./k3s.yaml
perl -pi -e 's/127\.0\.0\.1/<SERVER_PUBLIC_IP>/g' ./k3s.yaml
export KUBECONFIG="$PWD/k3s.yaml"
kubectl get nodes
```

## 4) GitHub Actions deploy secret (optional)

Base64-encode the kubeconfig (single line):

```bash
base64 -w0 k3s.yaml > kubeconfig.b64
```

Add repository secret **`KUBECONFIG_B64`** with the file contents, and configure GitHub Environment **`production`** if you use approvals.

## Notes

- Traefik is enabled by default on K3s; the manifests in [`../k8s/`](../k8s/) use `ingressClassName: traefik`.
- If pulls from GHCR fail for a private repository, create an `imagePullSecret` and reference it from the Deployment.
