resource "azurerm_resource_group" "engineering" {
  name     = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "engineering" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.3.0.0/16"]
  location            = azurerm_resource_group.engineering.location
  resource_group_name = azurerm_resource_group.engineering.name
}

resource "azurerm_network_security_group" "engineering" {
  name                = "${var.prefix}-base-sg"
  location            = azurerm_resource_group.engineering.location
  resource_group_name = azurerm_resource_group.engineering.name

  security_rule {
    name              = "ssh_http"
    priority          = 100
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "80",
      "443",
      "3389"
    ]
    source_address_prefix      = var.router_wan_ip
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Engineering"
  }
}

resource "azurerm_subnet" "engineering" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.engineering.name
  virtual_network_name = azurerm_virtual_network.engineering.name
  address_prefixes     = ["10.3.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "engineering" {
  subnet_id                 = azurerm_subnet.engineering.id
  network_security_group_id = azurerm_network_security_group.engineering.id
}

module "network-security-group" {
  source              = "Azure/network-security-group/azurerm"
  version             = "3.0.1"
  security_group_name = "base-nsg"
  resource_group_name = azurerm_resource_group.engineering.name
  predefined_rules = [
    {
      name     = "WinRM"
      priority = "500"
    }
  ]
  custom_rules = [
    {
      name                   = "base"
      priority               = "200"
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      destination_port_range = "22,80,443,3389"
      source_address_prefix  = var.router_wan_ip
      source_port_range      = "*"
      description            = "standard ports"
    }
  ]
  tags = {
    environment = "engineering"
    costcenter  = "it"
  }
}
