variable "location" {
  type = string
  description = "location where all resources will be deployed"
  default = "West Europe"
}

variable "resource_group_name" {
  type = string
  description = "resource group for deploying all resources"
  default = "aks-rg"
}