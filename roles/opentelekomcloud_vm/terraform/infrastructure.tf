data "opentelekomcloud_images_image_v2" "image" {
  name = var.image
}

resource "opentelekomcloud_compute_keypair_v2" "kp" {
  name       = var.keypair_name
  public_key = var.public_key
}

resource "opentelekomcloud_vpc_v1" "vpc" {
  cidr = var.cidr
  name = var.router_name
}

resource "opentelekomcloud_vpc_subnet_v1" "subnet" {
  cidr       = var.cidr
  gateway_ip = cidrhost(var.cidr, 1)
  name       = var.subnet_name
  vpc_id     = opentelekomcloud_vpc_v1.vpc.id
}

resource "opentelekomcloud_compute_floatingip_v2" "floating_ip" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_ecs_instance_v1" "ecs" {
  availability_zone = var.az
  flavor            = var.flavor
  image_id          = data.opentelekomcloud_images_image_v2.image.id
  name              = var.server_name
  vpc_id            = opentelekomcloud_vpc_v1.vpc.id
  key_name          = opentelekomcloud_compute_keypair_v2.kp.name

  system_disk_type = "SSD"
  system_disk_size = 20

  nics {
    network_id = opentelekomcloud_vpc_subnet_v1.subnet.network_id
  }

  security_groups = [
    opentelekomcloud_compute_secgroup_v2.sg.id
  ]
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "associate" {
  floating_ip = opentelekomcloud_compute_floatingip_v2.floating_ip.address
  instance_id = opentelekomcloud_ecs_instance_v1.ecs.id
}

resource "opentelekomcloud_compute_secgroup_v2" "sg" {
  description = "Keystone security group"
  name        = var.sg_name
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "rule_22" {
  security_group_id = opentelekomcloud_compute_secgroup_v2.sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "rule_5000" {
  security_group_id = opentelekomcloud_compute_secgroup_v2.sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5000
  port_range_max    = 5000
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "rule_37358" {
  security_group_id = opentelekomcloud_compute_secgroup_v2.sg.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 37358
  port_range_max    = 37358
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "rule_egress" {
  security_group_id = opentelekomcloud_compute_secgroup_v2.sg.id
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}

output "floating_ip" {
  value = opentelekomcloud_compute_floatingip_v2.floating_ip.address
}
