# =============================================================================
# Network layer — VCN, internet gateway, firewall rules, public subnet
# =============================================================================
# Think of this as wiring a mini data center in Oracle Cloud:
#   VCN = private network, Subnet = slice of IP addresses, Security List = firewall,
#   Route Table = "how to reach the internet", Internet Gateway = door to the public net.
# =============================================================================

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
  # Allows resources in public subnets to send/receive traffic from the internet.
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.project_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
    # Default route: "anything not local → send to the internet gateway."
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
    # protocol 6 = TCP. Only your admin IP range can SSH (port 22) if you set admin_cidr wisely.

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
    # Nodes inside the VCN can talk to each other on any TCP port (cluster internal traffic).

    tcp_options {
      min = 0
      max = 65535
    }
  }

  ingress_security_rules {
    description = "Intra-VCN UDP (Flannel VXLAN, etc.)"
    protocol    = "17"
    source      = var.vcn_cidr
    # protocol 17 = UDP — used by some Kubernetes networking overlays.

    udp_options {
      min = 0
      max = 65535
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    # Outbound: VMs may initiate connections anywhere (package updates, OpenWeather API, etc.).
  }
}

resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id

  availability_domain        = local.availability_domain
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 0)
  # Takes 10.0.0.0/16 and carves out 10.0.0.0/24 for this subnet.

  display_name               = "${var.project_name}-public"
  dns_label                  = "public"
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
  prohibit_public_ip_on_vnic = false
  # false = VMs in this subnet may receive a public IPv4 address.
}
