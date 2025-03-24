

# the environment variables env_prefix is critical for the different AKS clusters
env_prefix = "dev"
location = "West US 2"
kube_vnet_name = "aks-kubevnet"
kube_version_prefix = "1.30"
kube_resource_group_name = "gitops-aks-rg"
cluster_name = "gitops-aks"
nodepool_nodes_count = 2
nodepool_vm_size = "Standard_D4as_v5"
network_dns_service_ip = "178.51.0.10"
network_service_cidr = "178.51.0.0/16"
acr_name = "sitcleaninstall"
acr_resource_group = "rg-sdp-sit-clean-install"
address_space = ["10.4.0.0/22"]  # Changed from string to list of strings
username = "azureuser"
ssh_public_key = "~/.ssh/id_rsa.pub"
subnets = [
  {
    name             = "node-subnet"
    address_prefixes = ["10.4.0.0/24"]
    delegation       = ""
  },
  {
    name             = "pod-subnet"
    address_prefixes = ["10.4.1.0/24"]
    delegation       = "Microsoft.ContainerService/managedClusters"
  },
  {
    name             = "appgw-subnet"
    address_prefixes = ["10.4.2.0/24"]
    delegation       = ""
  },
  {
    name             = "ingress-subnet"
    address_prefixes = ["10.4.3.0/24"]
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
argocd_namespace = "argocd"
argocd_name = "argocd"


