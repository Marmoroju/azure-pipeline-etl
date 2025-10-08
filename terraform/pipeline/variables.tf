variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "acr_name" {
  type    = string
  default = "acrweatheretl"
}

variable "location" {
  type    = string
  default = "East US"
}