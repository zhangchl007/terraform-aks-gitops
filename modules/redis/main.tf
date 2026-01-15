terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.7.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.115.0"
    }
  }
}

locals {
  redis_enterprise_api_version = "2025-04-01"
  redis_name                   = lower(replace("${var.env_prefix}-${var.redis_name}", "_", "-"))
  
}



data "azurerm_resource_group" "redis" {
  name = var.resource_group_name
}


# Cluster definition
resource "azapi_resource" "cluster" {
  count     = var.use_azapi ? 1 : 0
  type      = "Microsoft.Cache/redisEnterprise@${local.redis_enterprise_api_version}"
  name      = var.redis_name
  location  = var.location
  parent_id = data.azurerm_resource_group.redis.id
  tags      = var.tags

  # HCL object (no jsonencode)
  body = {
    sku = {
      name = var.redis_sku_name
    }
    properties = {
      minimumTlsVersion = var.redis_minimum_tls_version
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "database" {
  count     = var.use_azapi ? 1 : 0
  type      = "Microsoft.Cache/redisEnterprise/databases@${local.redis_enterprise_api_version}"
  name      = var.database_name
  parent_id = azapi_resource.cluster[0].id

  body = {
    properties = {
      clientProtocol   = var.redis_client_protocol
      evictionPolicy   = var.redis_eviction_policy
      clusteringPolicy = "OSSCluster"
      persistence = {
        aofEnabled = false
        rdbEnabled = false
      }
      modules = [
        for m in var.modules : {
          name = m
        }
      ]
      accessKeysAuthentication = "Enabled"
    }
  }
  schema_validation_enabled = false
}

data "azapi_resource_action" "database_keys" {
  type        = "Microsoft.Cache/redisEnterprise/databases@${local.redis_enterprise_api_version}"
  resource_id = azapi_resource.database[0].id
  action      = "listKeys"
  method      = "POST"

  # Export primary and secondary keys from the action response
  response_export_values = ["primaryKey", "secondaryKey"]
}


