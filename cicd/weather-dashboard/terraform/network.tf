resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr]
  display_name   = "${var.project_name}-vcn"
  dns_label      = substr(replace(var.project_name, "-", ""), 0, 15)
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-igw"
  enabled        = true
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-public-sl"

  ingress_security_rules {
    description = "SSH from admin CIDR"
    protocol    = "6"
    source      = var.admin_cidr

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    description = "HTTP from internet (Ingress / Traefik)"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    description = "HTTPS from internet"
    protocol    = "6"
    source      = "0.0.0.0/0"

    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    description = "Intra-VCN TCP (K3s, kubelet, API, NodePorts, etc.)"
    protocol    = "6"
    source      = var.vcn_cidr

    tcp_options {
      min = 0
      max = 65535
    }
  }

  ingress_security_rules {
    description = "Intra-VCN UDP (Flannel VXLAN, etc.)"
    protocol    = "17"
    source      = var.vcn_cidr

    udp_options {
      min = 0
      max = 65535
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  availability_domain        = local.availability_domain
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name               = "${var.project_name}-public"
  dns_label                  = "public"
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_public_ip_on_vnic = false
}
