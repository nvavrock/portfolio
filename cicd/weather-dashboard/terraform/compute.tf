resource "oci_core_instance" "k3s" {
  count = 2

  availability_domain                 = local.availability_domain
  compartment_id                      = var.compartment_id
  display_name                        = count.index == 0 ? "${var.project_name}-k3s-0" : "${var.project_name}-k3s-1"
  shape                               = "VM.Standard.A1.Flex"
  is_pv_encryption_in_transit_enabled = true

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gbs
  }

  create_vnic_details {
    subnet_id              = oci_core_subnet.public.id
    assign_public_ip       = true
    skip_source_dest_check = false
  }

  source_details {
    source_type = "image"
    source_id   = local.instance_image_id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

data "oci_core_vnic_attachments" "instance" {
  count = length(oci_core_instance.k3s)

  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.k3s[count.index].id
}

data "oci_core_vnic" "instance" {
  count = length(oci_core_instance.k3s)

  vnic_id = data.oci_core_vnic_attachments.instance[count.index].vnic_attachments[0].vnic_id
}
