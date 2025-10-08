provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.terraform_remote_state.infra.outputs.resource_group
  location            = var.location
  sku                 = "Standard"

  identity {
    type = "SystemAssigned"
  }

  admin_enabled = false
}