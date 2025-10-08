data "terraform_remote_state" "infra" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-weather-etl"
    storage_account_name = "tfstateweatheretlmmrj"
    container_name       = "tfstate"
    key                  = "infra.tfstate"
  }
}