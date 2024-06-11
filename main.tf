data "azurerm_resource_group" "resource_group" {
  name     = "adam-sandbox"
}

# resource "azurerm_network_security_group" "public-security-group" {
#   name                = "public-security-group"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name

#   security_rule {
#     name                       = "AllowWorkHTTPInbound"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   tags = {
#     environment = var.environment
#   }
# }

# resource "azurerm_network_security_group" "private-security-group" {
#   name                = "private-security-group"
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   location            = data.azurerm_resource_group.resource_group.location

#   tags = {
#     environment = var.environment
#   }
# }

# resource "azurerm_virtual_network" "vnet" {
#   name                = "vnet"
#   resource_group_name = data.azurerm_resource_group.resource_group.name
#   location            = data.azurerm_resource_group.resource_group.location
#   address_space       = ["10.0.0.0/16"]
#   dns_servers         = ["10.0.0.4", "10.0.0.5"]

#   subnet {
#     name           = "subnet1"
#     address_prefix = "10.0.1.0/24"
#     security_group = azurerm_network_security_group.private-security-group.id
#   }

#   # subnet {
#   #   name           = "subnet2"
#   #   address_prefix = "10.0.2.0/24"
#   #   security_group = azurerm_network_security_group.public-security-group.id
#   # }

#   tags = {
#     environment = var.environment
#   }
# }

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "~> 8.0.0"

  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  prefix    = var.cluster_name
  kubernetes_version = var.cluster_version

  agents_pool_name = "default"
  agents_count = 1
  agents_min_count = 1
  agents_max_count = 10
  agents_size = "Standard_D2s_v3"

  role_based_access_control_enabled = true
  log_analytics_workspace_enabled   = false

  rbac_aad_managed = false
  rbac_aad  = false

  # vnet_subnet_id  = element(azurerm_virtual_network.vnet.subnet[*].id, count.index)

  os_disk_size_gb = 50
  os_disk_type = "Ephemeral"

  tags = {
    Environment = var.environment
  }
}