variable "keypair_name" {}
variable "router_name" {}
variable "cidr" {}
variable "subnet_name" {}
variable "flavor" { default = "s2.xlarge.4" }
variable "image" {}
variable "server_name" {}
variable "sg_name" {}
variable "az" { default = "eu-de-01" }
variable "public_key" {}
variable "inbound_ports" { type = list(number) }

