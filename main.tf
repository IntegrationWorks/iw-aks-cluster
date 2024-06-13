data "azurerm_resource_group" "resource_group" {
  name = "adam-sandbox"
}

data "azurerm_subnet" "vnet-subnet" {
  name                 = "subnet"
  virtual_network_name = "vnet"
  resource_group_name  = "adam-sandbox"
}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "~> 8.0.0"

  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  prefix             = var.cluster_name
  kubernetes_version = var.cluster_version

  agents_pool_name = var.agents_pool_name
  agents_count     = var.agents_count
  agents_min_count = var.agents_min_count
  agents_max_count = var.agents_max_count
  agents_size      = var.agents_size

  role_based_access_control_enabled = true
  log_analytics_workspace_enabled   = false

  rbac_aad_managed = false
  rbac_aad         = false

  vnet_subnet_id  = data.azurerm_subnet.vnet-subnet.id

  os_disk_size_gb = var.os_disk_size_gb
  os_disk_type    = var.os_disk_type

  tags = {
    Environment = var.environment
  }
}
