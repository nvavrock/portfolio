# =============================================================================
# Data lookups and computed local values (not created resources)
# =============================================================================
# "data" blocks read existing cloud information; "locals" are convenience variables
# reused in network.tf and compute.tf.
# =============================================================================

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
  # List Oracle datacenter "availability domains" in your tenancy (fault-isolation zones).
}

data "oci_core_images" "ubuntu_aarch64" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  # Find the newest Ubuntu 22.04 image that works on ARM Ampere (A1.flex) VMs.
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

locals {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  # Pick the first AD — enough for a small two-node demo cluster.

  instance_image_id = data.oci_core_images.ubuntu_aarch64.images[0].id
  # Newest matching Ubuntu image OCID — used when launching both K3s VMs.
}
