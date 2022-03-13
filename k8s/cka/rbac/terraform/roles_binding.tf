resource "kubernetes_role_binding" "main" {
  metadata {
    name      = "pod-reader"
    namespace = "default"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "pod-reader"
  }
  subject {
    kind      = "User"
    name      = "dev"
    api_group = "rbac.authorization.k8s.io"
  }
}