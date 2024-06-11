# example provider.tf
terraform {
  required_version = ">= 1.7"

  backend "azurerm" {
    resource_group_name  = "backstage-terraform"
    storage_account_name = "iwterraformstate"
    container_name       = "tf-state"
    key                  = "aks-cluster-terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}