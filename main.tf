locals {
  # Define the environment prefix
  kube_resource_group_name = "${var.env_prefix}-${var.kube_resource_group_name}"
  cluster_name           = "${var.env_prefix}-${var.cluster_name}"
  kube_vnet_name         = "${var.env_prefix}-${var.kube_vnet_name}"
  kubeconfig_path        = "${path.root}/modules/aks/${var.env_prefix}-kubeconfig"
}

resource "azurerm_resource_group" "kube" {
  name     = local.kube_resource_group_name  # Use the local value
  location = var.location
  tags = {
    environment = "Demo"
  }
}

module "kube_network" {
  source              = "./modules/vnet"
  resource_group_name = azurerm_resource_group.kube.name
  location            = var.location
  vnet_name           = local.kube_vnet_name  # Use the local value
  address_space       = var.address_space
  subnets             = var.subnets
}

module "aks" {
  source                 = "./modules/aks"
  kube_resource_group_name = local.kube_resource_group_name  # Use the local value
  location               = var.location
  cluster_name           = local.cluster_name  # Use the local value
  nodepool_nodes_count   = var.nodepool_nodes_count
  nodepool_vm_size       = var.nodepool_vm_size
  network_dns_service_ip = var.network_dns_service_ip
  network_service_cidr   = var.network_service_cidr
  username               = var.username
  ssh_public_key         = var.ssh_public_key
  env_prefix             = var.env_prefix
  kube_version_prefix    = var.kube_version_prefix
  #use_existing_acr         = var.use_existing_acr
  new_acr_name             = var.acr_name
  existing_acr_name        = var.acr_name
  existing_acr_resource_group = var.acr_resource_group
  # Pass network module outputs to AKS module
  subnet_ids   = module.kube_network.subnet_ids
  subnet_names = module.kube_network.subnet_names
}

# Create a kubeconfig file using a null_resource for ArgoCD
resource "null_resource" "generate_kubeconfig" {
  provisioner "local-exec" {
    command = "mkdir -p ${dirname(local.kubeconfig_path)} && az aks get-credentials --resource-group ${local.kube_resource_group_name} --name ${local.cluster_name} --file ${local.kubeconfig_path} --overwrite-existing"
  }
  
  triggers = {
    cluster_id = module.aks.cluster_id # Regenerate when cluster changes
  }
  
  depends_on = [module.aks]
}

# Add provider configurations
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.kube_config[0].client_certificate)
  client_key             = base64decode(module.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(module.aks.kube_config[0].cluster_ca_certificate)
}

#module "argocd" {
#
#  source            = "./modules/argocd"
#  argocd_repository = var.argocd_repository
#  argocd_name       = var.argocd_name
#  argocd_chart      = var.argocd_chart
#  argocd_version    = var.argocd_version
#  argocd_namespace  = var.argocd_namespace
#  kubeconfig_path   = local.kubeconfig_path
#
#  depends_on = [module.aks, null_resource.generate_kubeconfig]
#}

#module "agfc" {
#  source = "./modules/agfc"
#
#  resource_group_name = azurerm_resource_group.kube.name
#  location            = var.location
#  env_prefix          = var.env_prefix
#
#  vnet_id   = module.kube_network.vnet_id
#  subnet_id = module.kube_network.subnet_ids["appgw-subnet"]
#
#  agfc_name       = var.agfc_name
#  frontend_name   = var.agfc_frontend_name
#  frontend_ip     = var.agfc_frontend_ip
#
#  tags = {
#    Project    = "GitOps-AKS"
#    CostCenter = "Infrastructure"
#  }
#
#  depends_on = [module.kube_network]
#}
module "redis" {
  source = "./modules/redis"

  resource_group_name       = azurerm_resource_group.kube.name
  location                  = var.location
  env_prefix          = var.env_prefix
  redis_name                = var.redis_name
  redis_sku_name            = var.redis_sku_name
  redis_client_protocol     = var.redis_client_protocol
  redis_minimum_tls_version = var.redis_minimum_tls_version
  redis_enable_non_ssl_port = var.redis_enable_non_ssl_port
  redis_eviction_policy     = var.redis_eviction_policy

  database_name = var.redis_database_name
  modules       = var.redis_modules
  use_azapi    = var.redis_use_azapi

  tags = {
    Project    = "GitOps-AKS"
    CostCenter = "Infrastructure"
  }

  depends_on = [module.kube_network]
}

#module "cosmosdb" {
#  source = "./modules/cosmosdb"
#
#  resource_group_name = azurerm_resource_group.kube.name
#  location            = var.location
#  env_prefix          = var.env_prefix
#
#  subnet_ids = module.kube_network.subnet_ids
#
#  account_name   = var.cosmos_account_name
#  database_name  = var.cosmos_database_name
#  container_name = var.cosmos_container_name
#  throughput     = var.cosmos_throughput
#
#  tags = {
#    Project    = "GitOps-AKS"
#    CostCenter = "Infrastructure"
#  }
#
#  depends_on = [module.kube_network]
#}
#
#module "eventhub" {
#  source = "./modules/eventhub"
#
#  resource_group_name = azurerm_resource_group.kube.name
#  location            = var.location
#  env_prefix          = var.env_prefix
#
#  subnet_ids = module.kube_network.subnet_ids
#
#  # Wire root variables (set via dev/prod tfvars)
#  namespace_name          = var.eventhub_namespace_name
#  eventhub_name           = var.eventhub_name
#  sku_name                = var.eventhub_sku_name
#  capacity                = var.eventhub_capacity
#  message_retention       = var.eventhub_message_retention
#  partition_count         = var.eventhub_partition_count
#  enable_private_endpoint = var.eventhub_enable_private_endpoint
#
#  tags = {
#    Project    = "GitOps-AKS"
#    CostCenter = "Infrastructure"
#  }
#
#  depends_on = [module.kube_network]
#}
#module "mysql" {
#  source = "./modules/mysql"
#
#  resource_group_name = azurerm_resource_group.kube.name
#  location            = var.location
#  env_prefix          = var.env_prefix
#
#  subnet_ids = module.kube_network.subnet_ids
#
#  server_name        = var.mysql_server_name
#  admin_user         = var.mysql_admin_user
#  admin_password     = var.mysql_admin_password
#  mysql_version      = var.mysql_version  # Changed from 'version' to 'mysql_version'
#  database_name      = var.mysql_database_name
#  sku_name           = var.mysql_sku_name
#  storage_size       = var.mysql_storage_size
#  zone               = var.mysql_zone
#  availability_mode  = var.mysql_availability_mode
#
#  tags = {
#    Project    = "GitOps-AKS"
#    CostCenter = "Infrastructure"
#  }
#
#  depends_on = [module.kube_network]
#}
#module "vm" {
#  source = "./modules/vm"
#
#  resource_group_name = azurerm_resource_group.kube.name
#  location            = var.location
#  env_prefix          = var.env_prefix
#
#  vnet_id    = module.kube_network.vnet_id
#  subnet_ids = module.kube_network.subnet_ids
#
#  vms = var.vms
#
#  tags = {
#    Project    = "GitOps-AKS"
#    CostCenter = "Infrastructure"
#  }
#
#  depends_on = [module.kube_network]
#}