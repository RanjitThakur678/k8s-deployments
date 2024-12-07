terraform {
  required_version = ">=1.1.9" #terraform reqd version

  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0.0"
    }

    # azuread = {
    #   source  = "hashicorp/azuread"
    #   version = "~> 3.0.0"
    # }
  }

  ## Terrafprm backend for remote state files
  backend "azurerm" {
    resource_group_name = "tfstate-storage-rg"
    storage_account_name = "tfstate-storage"
    container_name = "tfstate-container"
    key = "tfresources.tfstate"
    
  }
}


###provider block###
provider "azurerm" {
    features {}
  
}