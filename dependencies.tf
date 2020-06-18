resource "azurerm_resource_group" "engineering" {
  name     = "${var.prefix}-rg"
  location = var.location
}
