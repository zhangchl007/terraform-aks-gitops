resource "azurerm_user_assigned_identity" "aks" {
  location            = azurerm_resource_group.kube.location
  name                = "${random_pet.rg.id}-aksmi"
  resource_group_name = azurerm_resource_group.kube.name
}

resource "azurerm_role_assignment" "aks_network" {
  scope                = var.subnet_ids["node-subnet"]
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

# Assign Network Contributor role to the AKS service principal for the Application Gateway subnet.
resource "azurerm_role_assignment" "aks_appgw_subnet" {
  principal_id         = azurerm_kubernetes_cluster.k8s.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  role_definition_name = "Network Contributor"
  scope                = var.subnet_ids["appgw-subnet"]  # Use subnet ID, not name
}

# Assign AcrPull role to the AKS cluster identity on the ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = local.acr_id
  skip_service_principal_aad_check = true
}
# Create a federated credential for the user-assigned identity
#resource "azurerm_federated_identity_credential" "aks_federated_credential" {
#  name                = "aks-federated-credential"
#  resource_group_name = azurerm_resource_group.kube.name
#  issuer              = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
#  subject             = "system:serviceaccount:default:my-service-account"
#  #audience            = "api://AzureADTokenExchange"
#  audience            = ["api://AzureADTokenExchange"]
#  parent_id           = azurerm_user_assigned_identity.aks.id
#}