output "resource_group" {
  value = azurerm_resource_group.rg.name
}

# Storage Account usado para armazenar os dados do ETL
output "etl_storage_account_name" {
  value = azurerm_storage_account.etldata.name
}

output "etl_container_name" {
  value = azurerm_storage_container.etldata.name
}

output "tfstate_storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "tftstate_container_name" {
  value = azurerm_storage_container.tfstate.name
}
