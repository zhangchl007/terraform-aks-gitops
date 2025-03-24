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
  # Pass network module outputs to AKS module
  subnet_ids   = module.kube_network.subnet_ids
  subnet_names = module.kube_network.subnet_names
  existing_acr_name           = var.acr_name
  existing_acr_resource_group = var.acr_resource_group

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
  config_path = local.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_path
  }
}

module "argocd" {

  source            = "./modules/argocd"
  argocd_repository = var.argocd_repository
  argocd_name       = var.argocd_name
  argocd_chart      = var.argocd_chart
  argocd_version    = var.argocd_version
  kubeconfig_path   = local.kubeconfig_path
  
  #depends_on = [null_resource.generate_kubeconfig]

}