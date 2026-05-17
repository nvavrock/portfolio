# =============================================================================
# Terraform version and Oracle Cloud (OCI) provider setup
# =============================================================================
# Terraform reads all .tf files in this folder as one configuration.
# `terraform init` downloads the OCI provider; `terraform apply` creates resources.
# =============================================================================

terraform {
  required_version = ">= 1.5.0"
  # Minimum Terraform CLI version for language features used here.

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
      # Plugin that talks to Oracle Cloud APIs (~> 6.0 allows 6.x patches).
    }
  }
}

provider "oci" {
  # Credentials come from variables (set via TF_VAR_* environment variables).
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
}
