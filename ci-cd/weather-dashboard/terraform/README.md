# OCI Terraform (weather-dashboard)

## In plain terms

This folder is **Infrastructure as Code** for Oracle Cloud. Instead of clicking in a web console to create networks and servers, you describe them in `.tf` files and run `terraform apply`. Terraform then:

1. Creates a **virtual network** (VCN) and **firewall rules** (security list).
2. Creates a **public subnet** (a slice of IP addresses reachable from the internet).
3. Launches **two small ARM Linux VMs** where you will install K3s (Kubernetes).

Terraform does **not** install Kubernetes or deploy the weather app — that happens afterward with `scripts/` and `k8s/`.

---

Provision a small **VCN**, **public subnet**, and **two `VM.Standard.A1.Flex`** instances suitable for installing **K3s**.

## Prerequisites

- An OCI tenancy and a user with an **API key** (fingerprint + private key PEM).
- A **compartment OCID** (often the root compartment equals the tenancy OCID).
- An **SSH public key** for the default image user (**`ubuntu`** on Canonical Ubuntu images).

## Authentication (recommended)

Export variables instead of committing secrets:

```bash
export TF_VAR_tenancy_ocid="ocid1.tenancy..."
export TF_VAR_user_ocid="ocid1.user..."
export TF_VAR_fingerprint="aa:bb:..."
export TF_VAR_private_key="$(cat ~/.oci/oci_api_key.pem)"
export TF_VAR_region="uk-london-1"
export TF_VAR_compartment_id="ocid1.compartment..."
export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_ed25519.pub)"
```

## Apply

```bash
cd ci-cd/weather-dashboard/terraform
terraform init
terraform plan
terraform apply
```

## Outputs

- `k3s_public_ipv4`: use the first node as the K3s server bootstrap target.
- `k3s_private_ipv4`: use for internal API URLs if you keep the API private later.

## Security notes

- `admin_cidr` defaults to `0.0.0.0/0` for SSH; set it to your public IP `/32` before `apply`.
- State files contain sensitive metadata; keep them out of git (see `../.gitignore`).

## Which `.tf` file does what?

| File | Purpose |
|------|---------|
| `versions.tf` | Terraform & OCI provider versions; cloud login settings |
| `variables.tf` | Inputs you must supply (keys, region, SSH key, sizes) |
| `locals.tf` | Looks up Ubuntu image & availability domain |
| `network.tf` | VCN, subnet, internet gateway, firewall |
| `compute.tf` | Two VMs for K3s server + agent |
| `outputs.tf` | IPs and IDs printed after apply |
