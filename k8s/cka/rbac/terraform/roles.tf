resource "kubernetes_role" "main" {
  metadata {
    name      = "pod-reader"
    namespace = "default"
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "pods/logs"]
    verbs      = ["get", "watch", "list"]
  }
}