

resource "random_pet" "rg" {
  length = 1
  prefix = var.env_prefix
}

locals {
  appgw_name    = "${replace(random_pet.rg.id, "-", "")}appgw"
  kubefile_name = "${var.env_prefix}-kubeconfig"
}
resource "azurerm_resource_group" "kube" {
  name     = var.kube_resource_group_name
  location = var.location
  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = var.location
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  resource_group_name = azurerm_resource_group.kube.name
  dns_prefix          = random_pet.rg.id

  private_cluster_enabled = false
  azure_policy_enabled    = false

  default_node_pool {
    name           = "systempool"
    os_sku         = "AzureLinux"
    node_count     = var.nodepool_nodes_count
    vm_size        = var.nodepool_vm_size
    vnet_subnet_id = var.subnet_ids["node-subnet"]
    pod_subnet_id  = var.subnet_ids["pod-subnet"]

  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = false

  # Add app-routing configuration
  web_app_routing {
    # Required: List of DNS zone resource IDs for web app routing

    dns_zone_ids = []
  }

  ingress_application_gateway {
    gateway_name = local.appgw_name
    subnet_id    = var.subnet_ids["appgw-subnet"]
  }

  identity {
    #type = "SystemAssigned"
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    dns_service_ip    = var.network_dns_service_ip
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = var.network_service_cidr

  }

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  depends_on = [azurerm_user_assigned_identity.aks]

}

resource "azurerm_kubernetes_cluster_node_pool" "spotnodepool" {

  name                  = "spotnodepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = var.nodepool_vm_size
  os_sku                = "AzureLinux"
  node_count            = 2
  #priority              = "Spot"
  #eviction_policy       = "Delete"
  #spot_max_price        = 0.2 # note: this is the "maximum" price
  #node_labels = {
  #  "kubernetes.azure.com/scalesetpriority" = "spot"
  #}
  #node_taints = [
  #  "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  #]
  os_disk_size_gb = 512
  #os_type = "Linux"
  vnet_subnet_id = var.subnet_ids["node-subnet"]
  pod_subnet_id  = var.subnet_ids["pod-subnet"]
  depends_on     = [azurerm_kubernetes_cluster.k8s]
  mode           = "User"

}

resource "null_resource" "wait_for_kubeconfig" {
  provisioner "local-exec" {
    command     = " az account set --subscription ${data.azurerm_subscription.current.subscription_id} && az aks get-credentials --resource-group ${azurerm_resource_group.kube.name} --name ${azurerm_kubernetes_cluster.k8s.name} --overwrite-existing --admin"
    working_dir = path.module
  }
  depends_on = [azurerm_kubernetes_cluster.k8s]
}

resource "local_file" "kubeconfig" {
  content    = azurerm_kubernetes_cluster.k8s.kube_admin_config_raw != "" ? azurerm_kubernetes_cluster.k8s.kube_admin_config_raw : azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename   = "${path.module}/${local.kubefile_name}"
  depends_on = [null_resource.wait_for_kubeconfig]
}






