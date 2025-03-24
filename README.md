# Private AKS Terraform
This is a Terraform script to create a private AKS cluster in Azure. The script creates a VNET, a subnet, a private AKS cluster

# Bootstrap
./tf-bootstrap.sh

# Configuration

```bash

cat <<EOF > providers.tf

terraform {

  #Uncomment this block to use Terraform Cloud for this tutorial
  /*cloud {
    organization = "devops-learn-terraform"
    workspaces {
      name = "azure-module-vm02"
    }
}*/

  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.23.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfdemo"
    storage_account_name = "tfdemotfstate$RANDOM"
    container_name       = "tfstate$RANDOM"
    key                  = "tfaks.tfstate"
  }
}

provider "azapi" {
   alias  = "chazapi"

}

provider "azurerm" {
  features {}
}

/*
module "linux-instance" {
  source = "./modules/"
  providers = {
    azapi = azapi.chazapi
  }
  
}*/

EOF

```

# Running the script
After you configure authentication with Azure, just init and apply (no inputs are required):

```bash
export ARM_USE_MSI=true
export ARM_SUBSCRIPTION_ID= `az account show --query id -o tsv`
export ARM_TENANT_ID = `az account show --query tenantId -o tsv`
export ARM_ACCESS_KEY=`az keyvault secret show --name terraform-backend-key --vault-name
 tfstatevault --query value -o tsv`
 

terraform init \
  -backend-config="resource_group_name=tfdemo" \
  -backend-config="storage_account_name=tfdemotfstate3645" \
  -backend-config="container_name=tfstate3643" \
  -backend-config="key=tfaks.tfstate"


tf workspace new dev
tf workspace new prod
tf workspace select dev
tf plan -out devplan -var-file="./environments/dev-variables.tfvars"
tf apply devplan
# Create a new workspace for production

tf workspace select prod
tf plan -out prodplan -var-file="./environments/prod-variables.tfvars"
tf apply prodplan

```# terraform-aks-gitops
