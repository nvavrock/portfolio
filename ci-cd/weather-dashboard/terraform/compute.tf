# =============================================================================
# Compute — two ARM virtual machines for a small K3s cluster
# =============================================================================
# count = 2 creates two nearly identical instances:
#   index 0 → intended K3s server (control plane)
#   index 1 → intended K3s agent (worker)
# You still install K3s manually/scripts after Terraform finishes (see scripts/).
# =============================================================================

resource "oci_core_instance" "k3s" {
  count = 2

  availability_domain                 = local.availability_domain
  compartment_id                      = var.compartment_id
  display_name                        = count.index == 0 ? "${var.project_name}-k3s-0" : "${var.project_name}-k3s-1"
  shape                               = "VM.Standard.A1.Flex"
  # Ampere ARM shape — eligible for Oracle "Always Free" tier when within limits.

  is_pv_encryption_in_transit_enabled = true

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gbs
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.public.id
    assign_public_ip       = true
    skip_source_dest_check = false
    # Network interface on the public subnet with a routable public IP.
  }

  source_details {
    source_type = "image"
    source_id   = local.instance_image_id
    # Boot from the Ubuntu 22.04 ARM image looked up in locals.tf.
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    # Injects your SSH public key so you can log in as user `ubuntu`.
  }
}

data "oci_core_vnic_attachments" "instance" {
  count = length(oci_core_instance.k3s)

  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.k3s[count.index].id
  # For each VM, find its virtual network interface attachment.
}

data "oci_core_vnic" "instance" {
  count = length(oci_core_instance.k3s)

  vnic_id = data.oci_core_vnic_attachments.instance[count.index].vnic_attachments[0].vnic_id
  # Read public/private IP addresses — exposed as terraform outputs.
}
