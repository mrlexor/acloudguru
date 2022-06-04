resource "kubernetes_ingress" "main" {
  metadata {
    name = "web-auth-ingress"
  }
  spec {
    rule {
      http {
        path {
          path = "/auth"
          backend {
            service_name = "web-auth-svc"
            service_port = 80
          }
        }
      }
    }
  }
}