# the environment variables env_prefix is critical for the different AKS clusters
env_prefix               = "neolix"
location                 = "UAE North"
kube_vnet_name           = "vnet-uaenorth"
kube_version_prefix      = "1.33"
kube_resource_group_name = "rg-neolix-test"
cluster_name             = "test-aks-1"
nodepool_nodes_count     = 2
nodepool_vm_size         = "Standard_D2s_v3"
network_dns_service_ip   = "172.15.0.10"
network_service_cidr     = "172.15.0.0/24"
acr_name                 = "neolixacr01"
acr_resource_group       = "neolix-rg-neolix-test"
address_space            = ["172.15.0.0/16"]
username                 = "azureuser"
ssh_public_key           = "~/.ssh/id_rsa.pub"
subnets = [
  {
    name             = "node-subnet"
    address_prefixes = ["172.15.1.0/24"]
    delegation       = ""
  },
  {
    name             = "pod-subnet"
    address_prefixes = ["172.15.2.0/24"]
    delegation       = "Microsoft.ContainerService/managedClusters"
  },
  {
    name             = "appgw-subnet"
    address_prefixes = ["172.15.3.0/24"]
    delegation       = "Microsoft.ServiceNetworking/trafficControllers"
  },
  {
    name             = "ingress-subnet"
    address_prefixes = ["172.15.4.0/24"]
    delegation       = ""
  },
  {
    name             = "mysql-subnet"
    address_prefixes = ["172.15.5.0/24"]
    delegation       = "Microsoft.DBforMySQL/flexibleServers"
  },
  {
    name             = "privateendpoint-subnet"
    address_prefixes = ["172.15.6.0/24"]
    delegation       = ""
  }
]

## ingress controller
#ingress_repository = "https://kubernetes.github.io/ingress-nginx"
#ingress_chart      = "ingress-nginx"
#ingress_version    = "4.11.3"
#ingress_namespace = "ingress-nginx"

##argocd
#argocd_repository = "https://argoproj.github.io/argo-helm"
#argocd_chart      = "argo-cd"
#argocd_version    = "7.8.12"
#argocd_namespace = "argocd"
#argocd_name = "argocd"

## Managed Redis
redis_name                = "redis1"
redis_sku_name            = "Balanced_B5"
redis_client_protocol     = "Encrypted"
redis_minimum_tls_version = "1.2"
redis_enable_non_ssl_port = false
redis_eviction_policy     = "allkeys-lru"
redis_database_name       = "default"
redis_modules             = ["RedisBloom", "RedisTimeSeries"]
redis_use_azapi           = true

## Cosmos DB
cosmos_account_name   = "test-cosmos-1"
cosmos_database_name  = "appdb"
cosmos_container_name = "items"
cosmos_throughput     = 400

## Event Hub (optional overrides)
eventhub_namespace_name          = "test-ehns-1"
eventhub_name                    = "events"
eventhub_sku_name                = "Standard"
eventhub_capacity                = 1
eventhub_message_retention       = 1
eventhub_partition_count         = 2
eventhub_enable_private_endpoint = true


## MySQL Flexible Server
mysql_server_name       = "neolix-mysql-1"
mysql_admin_user        = "mysqladmin"
mysql_admin_password    = "ChangeMe123!"
mysql_version           = "8.0.21"
mysql_database_name     = "appdb"
mysql_sku_name          = "GP_Standard_D2ds_v4" # Changed from B_Standard_B2s to Standard_B2s (General Purpose)
mysql_storage_size      = 128                   # GB
mysql_zone              = "1"
mysql_availability_mode = "ZoneRedundant" # High Availability supported

# Network: we already have mysql-subnet in `subnets`
#   name = "mysql-subnet"
#   address_prefixes = ["172.15.5.0/24"]
#   delegation = ""
# The mysql module should use module.kube_network.subnet_ids["mysql-subnet"]

## Virtual Machines (Batch Configuration)
vms = {
  jumpserver = {
    vm_name             = "jumpserver"
    vm_size             = "Standard_B2s"
    subnet_name         = "node-subnet"
    admin_username      = "azureuser"
    ssh_public_key_path = "~/.ssh/id_rsa.pub"
    os_type             = "linux"
    enable_public_ip    = true
    nsg_rules = [
      {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowRDP"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Purpose = "BastionHost"
    }
  }

  rocketmq = {
    vm_name             = "rocketmq"
    vm_size             = "Standard_D2s_v3"
    subnet_name         = "node-subnet"
    admin_username      = "azureuser"
    ssh_public_key_path = "~/.ssh/id_rsa.pub"
    os_type             = "linux"
    enable_public_ip    = true
    nsg_rules = [
      {
        name                       = "AllowSSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowRocketMQNameServer"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "9876"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowRocketMQBroker"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "10911"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowRocketMQBrokerHA"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "10912"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowRocketMQConsole"
        priority                   = 104
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Purpose = "MessageBroker"
    }
  }
}


