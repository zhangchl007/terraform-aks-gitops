

# the environment variables env_prefix is critical for the different AKS clusters
env_prefix               = "main"
location                 = "Brazil South"
kube_vnet_name           = "aks-vnet"
kube_version_prefix      = "1.30"
kube_resource_group_name = "argocd-istio-rg"
cluster_name             = "gitops-aks"
nodepool_nodes_count     = 2
nodepool_vm_size         = "Standard_D4as_v5"
network_dns_service_ip   = "178.55.0.10"
network_service_cidr     = "178.55.0.0/16"
acr_name                 = "devdevaphidacr"
acr_resource_group       = "dev-argocd-istio-rg"
address_space            = ["10.5.0.0/16"] # Changed from string to list of strings
username                 = "azureuser"
ssh_public_key           = "~/.ssh/id_rsa.pub"
subnets = [
  {
    name             = "node-subnet"
    address_prefixes = ["10.5.0.0/20"]
    delegation       = ""
  },
  {
    name             = "pod-subnet"
    address_prefixes = ["10.5.16.0/20"]
    delegation       = "Microsoft.ContainerService/managedClusters"
  },
  {
    name             = "appgw-subnet"
    address_prefixes = ["10.5.32.0/24"]
    delegation       = ""
  },
  {
    name             = "ingress-subnet"
    address_prefixes = ["10.5.33.0/24"]
    delegation       = "Microsoft.ServiceNetworking/trafficControllers"
  }

]

## ingress controller
#ingress_repository = "https://kubernetes.github.io/ingress-nginx"
#ingress_chart      = "ingress-nginx"
#ingress_version    = "4.11.3"
#ingress_namespace = "ingress-nginx"

##argocd
argocd_repository = "https://argoproj.github.io/argo-helm"
argocd_chart      = "argo-cd"
argocd_version    = "7.8.12"
argocd_namespace  = "argocd"
argocd_name       = "argocd"


