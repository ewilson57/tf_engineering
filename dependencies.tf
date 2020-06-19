resource "azurerm_resource_group" "engineering" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "engineering" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.engineering.location
  resource_group_name = azurerm_resource_group.engineering.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "engineering" {
  name                = "${var.prefix}-base-sg"
  location            = azurerm_resource_group.engineering.location
  resource_group_name = azurerm_resource_group.engineering.name

  security_rule {
    name              = "standard_ports"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "80",
      "443",
      "3389",
      "5985",
      "5986"
    ]
    source_address_prefix      = var.router_wan_ip
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet" "engineering" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.engineering.name
  virtual_network_name = azurerm_virtual_network.engineering.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

resource "azurerm_subnet_network_security_group_association" "engineering" {
  count                     = length(var.subnet_names)
  subnet_id                 = azurerm_subnet.engineering[count.index].id
  network_security_group_id = azurerm_network_security_group.engineering.id
}

resource "azurerm_availability_set" "linux-avset" {
  name                         = "linux-avset"
  resource_group_name          = azurerm_resource_group.engineering.name
  location                     = azurerm_resource_group.engineering.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 3
  managed                      = true
  tags                         = var.tags
}

resource "azurerm_availability_set" "windows-avset" {
  name                         = "windows-avset"
  resource_group_name          = azurerm_resource_group.engineering.name
  location                     = azurerm_resource_group.engineering.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 3
  managed                      = true
  tags                         = var.tags
}
