variable "prefix" {
  description = "The Prefix used for all resources in this example"
  default     = "engineering"
}

variable "location" {
  default = "South Central US"
}

variable "address_space" {
  default = "10.3.0.0/16"
}

variable "subnet_prefixes" {
  default = [
    "10.3.0.0/24",
    "10.3.1.0/24",
    "10.3.2.0/24"
  ]
}

variable "subnet_names" {
  default = [
    "subnet1",
    "subnet2",
    "subnet3"
  ]
}

variable "tags" {
  default = {
    environment = "Engineering"
    costcenter  = "IT"
  }
}

variable "arm_client_id" {}
variable "arm_client_secret" {}
variable "arm_tenant_id" {}
variable "arm_subscription_id" {}
variable "router_wan_ip" {}
variable "admin_username" {}
variable "admin_password" {}
variable "ssh_key" {}
