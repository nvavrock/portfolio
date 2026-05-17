# =============================================================================
# Outputs — values printed after terraform apply (for humans and scripts)
# =============================================================================
# Run: terraform output
# Use k3s_public_ipv4 to SSH in and bootstrap K3s (see scripts/k3s-bootstrap.md).
# =============================================================================

output "vcn_id" {
  description = "VCN OCID — ID of the virtual cloud network Terraform created."
  value       = oci_core_vcn.this.id
}

output "public_subnet_id" {
  description = "Public subnet OCID — subnet where VMs get public IPs."
  value       = oci_core_subnet.public.id
}

output "k3s_instance_ids" {
  description = "Compute instance OCIDs for the two K3s nodes."
  value       = oci_core_instance.k3s[*].id
}

output "k3s_public_ipv4" {
  description = "Public IPv4 addresses (same order as instances) — use [0] for SSH to server node."
  value       = [for v in data.oci_core_vnic.instance : v.public_ip_address]
}

output "k3s_private_ipv4" {
  description = "Private IPv4 addresses (same order as instances) — use [0] in K3S_URL for agents."
  value       = [for v in data.oci_core_vnic.instance : v.private_ip_address]
}

output "ssh_hint" {
  description = "Ubuntu images on OCI typically use the ubuntu user."
  value       = "ssh ubuntu@<k3s_public_ipv4[0]>"
}
