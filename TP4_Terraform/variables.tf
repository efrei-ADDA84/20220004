variable "vm_name" {
  default = "devops-20220004"
}

variable "admin_username" {
  default = "devops"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "subnet_name" {
  default = "internal"
}

variable "virtual_network_name" {
  default = "network-tp4"
}

variable "subnet_address_prefix" {
  default = "10.0.1.0/24"
}

variable "location" {
  default = "francecentral"
}

variable "resource_group_name" {
  default = "ADDA84-CTP"
}

variable "subscription_id" {
  default = "765266c6-9a23-4638-af32-dd1e32613047"
}