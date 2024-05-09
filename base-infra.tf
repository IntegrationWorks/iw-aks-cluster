resource "azurerm_resource_group" "network" {
  name     = "adam-sandbox-network"
  location = "Australia East"
}

resource "azurerm_network_security_group" "public-security-group" {
  name                = "public-security-group"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.api-gw-rg.name

  security_rule {
    name                       = "AllowWorkHTTPInbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_security_group" "private-security-group" {
  name                = "private-security-group"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name

  tags = {
    environment = var.environment
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "basic-network"
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.private-security-group.id
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.public-security-group.id
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "aks-storage-account" {
  name                     = "aks-storage-account"
  resource_group_name      = azurerm_resource_group.network.name
  location                 = azurerm_resource_group.network.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_container" "aks-storage-container" {
  name                  = "aks-storage-container"
  storage_account_name  = azurerm_storage_account.aks-storage-account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "aks-storage-blob" {
  name                   = "aks-storage-blob"
  storage_account_name   = azurerm_storage_account.aks-storage-account.name
  storage_container_name = azurerm_storage_container.aks-storage-container.name
  type                   = "Block"
  source                 = "terraform.tfstate"
}