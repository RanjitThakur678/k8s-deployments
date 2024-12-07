
### resource group for aks-cluster 
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

####vnet for aks cluster##############

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}


###subnet for aks-cluster#################

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

#############aks-cluster config##########

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${azurerm_resource_group.aks_rg.name}-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  dns_prefix          = "${azurerm_resource_group.aks_rg.name}-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}


####User node pool for slave nodes##############
resource "azurerm_kubernetes_cluster_node_pool" "aks-user-node-pool" {
  name                  = "system-node-pool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  min_count             = 1
  max_count             = 4
  enable_auto_scaling   = true
  orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_type               = "Linux"
  vnet_subnet_id = azurerm_subnet.aks_subnet.id

  node_labels = {
    "environment"   = "Production"
  }
  
  tags = {
    Environment = "Production"
  }
}