# =============================================================================
# Input variables — settings you pass in before terraform apply
# =============================================================================
# Prefer exporting TF_VAR_<name> in your shell (see terraform/README.md) instead of
# committing secrets in .tfvars files.
# =============================================================================

variable "tenancy_ocid" {
  type        = string
  description = "Oracle Cloud tenancy OCID — your cloud account's unique ID."
}

variable "user_ocid" {
  type        = string
  description = "API user OCID — the IAM user Terraform authenticates as."
}

variable "fingerprint" {
  type        = string
  description = "API key fingerprint — matches the public key uploaded for that user."
}

variable "private_key" {
  type        = string
  sensitive   = true
  description = "PEM private key for the API user. Prefer TF_VAR_private_key instead of tfvars files."
}

variable "region" {
  type        = string
  description = "OCI region identifier, for example uk-london-1 — where resources are created."
}

variable "compartment_id" {
  type        = string
  description = "Compartment OCID where resources are created (often the same as tenancy root compartment)."
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key material for the default image user (Ubuntu images use ubuntu)."
}

variable "admin_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed to reach TCP/22 (SSH). Prefer your home IP with /32, not the whole internet."
}

variable "vcn_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VCN IPv4 CIDR — private address space for your virtual network (65k-ish addresses)."
}

variable "project_name" {
  type        = string
  default     = "weather"
  description = "Prefix for resource display names in the OCI console (weather-vcn, weather-k3s-0, etc.)."
}

variable "instance_ocpus" {
  type        = number
  default     = 1
  description = "OCPUs per Ampere A1.flex instance (Always Free total across all A1 instances is capped)."
}

variable "instance_memory_gbs" {
  type        = number
  default     = 6
  description = "Memory in GB per instance (must be allowed for the chosen OCPU count)."
}
