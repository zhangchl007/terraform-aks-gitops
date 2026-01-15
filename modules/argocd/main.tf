resource "kubernetes_namespace" "argocd" {

  metadata {
    name = var.argocd_namespace
  }
}
resource "helm_release" "argocd" {
  name       = var.argocd_name
  repository = var.argocd_repository
  chart      = var.argocd_chart
  version    = var.argocd_version

  namespace = kubernetes_namespace.argocd.metadata[0].name

  # Enable upgrade functionality
  force_update    = true
  cleanup_on_fail = true
  atomic          = true
  timeout         = 900
  wait            = true

  values = [<<EOF
server:
  extraArgs:
    - --insecure
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-internal: "true"
repoServer:
  env:
    - name: ARGOCD_GIT_ATTEMPTS_COUNT
      value: "5"
    - name: ARGOCD_REPO_SERVER_PLAINTEXT
      value: "true"
dex:
  enabled: false
EOF
  ]

  depends_on = [kubernetes_namespace.argocd]
}