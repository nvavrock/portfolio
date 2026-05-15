# OCI Terraform (weather-dashboard)

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
cd cicd/weather-dashboard/terraform
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
