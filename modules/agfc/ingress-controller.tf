
locals {
  ingress_name = "${replace(random_pet.rg.id, "-", "")}ingress"
}
resource "kubernetes_namespace" "ingress" {  
  metadata {
    name = var.ingress_namespace
    labels = {
      name = var.ingress_namespace
    }
  }
}
resource "helm_release" "ingress" {
  name       = local.ingress_name
  repository = var.ingress_repository
  chart      = var.ingress_chart
  version    = var.ingress_version
  namespace = kubernetes_namespace.ingress.metadata[0].name
  create_namespace = true


  depends_on = [kubernetes_namespace.ingress]
}