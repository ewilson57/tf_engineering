variable "prefix" {
  description = "The Prefix used for all resources in this example"
  default     = "engineering"
}

variable "location" {
  default = "South Central US"
}

variable "router_wan_ip" {}
variable "admin_username" {}
variable "admin_password" {}
variable "ssh_key" {}

