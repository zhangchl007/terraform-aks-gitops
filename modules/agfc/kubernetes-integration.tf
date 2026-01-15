
# Namespace for AGFC ingress controller
resource "kubernetes_namespace" "agfc" {
  metadata {
    name = "agfc-system"
    labels = {
      "app.kubernetes.io/name"      = "agfc"
      "app.kubernetes.io/component" = "ingress"
    }
  }
}

# Create service account for AGFC
resource "kubernetes_service_account" "agfc" {
  metadata {
    name      = "agfc-controller"
    namespace = kubernetes_namespace.agfc.metadata[0].name
  }

  depends_on = [kubernetes_namespace.agfc]
}

# Create cluster role for AGFC
resource "kubernetes_cluster_role" "agfc" {
  metadata {
    name = "agfc-controller"
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get"]
  }

  depends_on = [kubernetes_service_account.agfc]
}

# Create cluster role binding
resource "kubernetes_cluster_role_binding" "agfc" {
  metadata {
    name = "agfc-controller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.agfc.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.agfc.metadata[0].name
    namespace = kubernetes_namespace.agfc.metadata[0].name
  }

  depends_on = [kubernetes_cluster_role.agfc]
}