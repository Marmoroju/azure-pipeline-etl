variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "resource_group_name" {
  type    = string
  default = "rg-weather-etl"
}

variable "location" {
  type    = string
  default = "East US"
}

# tfstate
variable "sa_tfstate" {
  type    = string
  default = "tfstateweatheretlmmrj"
}

variable "sc_tfstate" {
  type    = string
  default = "tfstate"
}

# ETL
variable "sa_etldata" {
  type    = string
  default = "dadosweatheretlmmrj"
}

variable "sc_etldata" {
  type    = string
  default = "etldata"
}