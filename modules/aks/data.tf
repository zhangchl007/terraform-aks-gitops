/*
data "azurerm_subnet" "aks" {
  name                 = element(split("/", azurerm_kubernetes_cluster.k8s.default_node_pool[0].vnet_subnet_id), 10)
  virtual_network_name = element(split("/", azurerm_kubernetes_cluster.k8s.default_node_pool[0].vnet_subnet_id), 8)
  resource_group_name  = azurerm_kubernetes_cluster.k8s.resource_group_name

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}

# Find all agent node ids by extracting it's name from subnet assigned to cluster:
data "azurerm_virtual_machine" "aks-node" {
  # This resource represent each node created for aks cluster.
  count               = var.nodepool_nodes_count
  name                = distinct([for x in data.azurerm_subnet.aks.ip_configurations : replace(element(split("/", x), 8), "/nic-/", "")])
  resource_group_name = azurerm_resource_group.kube.name

  depends_on = [
    azurerm_subnet.aks
  ]
}

# Create disk resource in size of aks nodes:
resource "azurerm_managed_disk" "aks-extra-disk" {
  count                = var.nodepool_nodes_count
  name                 = "${azurerm_kubernetes_cluster.k8s.name}-disk-${count.index}"
  location             = azurerm_kubernetes_cluster.k8s.location
  resource_group_name  = azurerm_kubernetes_cluster.k8s.resource_group_name
  storage_account_type = "PremiumV2_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

# Attach our disks to each agents:
resource "azurerm_virtual_machine_data_disk_attachment" "aks-disk-attachment" {
  count              = var.nodepool_nodes_count
  managed_disk_id    = azurerm_managed_disk.aks-extra-disk[count.index].id
  virtual_machine_id = data.azurerm_virtual_machine.aks-node[count.index].id
  lun                = "10"
  caching            = "ReadWrite"
}*/


data "azurerm_kubernetes_service_versions" "current" {
  location       = var.location
  version_prefix = var.kube_version_prefix
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}