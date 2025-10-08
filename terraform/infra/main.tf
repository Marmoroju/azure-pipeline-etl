provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account para o tfstate
resource "azurerm_storage_account" "tfstate" {
  name                     = var.sa_tfstate
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.sc_tfstate
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# Storage Account para dados do ETL
resource "azurerm_storage_account" "etldata" {
  name                              = var.sa_etldata
  resource_group_name               = azurerm_resource_group.rg.name
  location                          = azurerm_resource_group.rg.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  min_tls_version                   = "TLS1_2"
  infrastructure_encryption_enabled = true
}

resource "azurerm_storage_container" "etldata" {
  name                  = var.sc_etldata
  storage_account_id    = azurerm_storage_account.etldata.id
  container_access_type = "private"
}