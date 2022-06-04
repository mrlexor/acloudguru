resource "kubernetes_service" "main" {
  metadata {
    name = "web-auth-svc"
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "web-auth"
    }
    port {
      name = "http"
      protocol = "TCP"
      port = 80
      target_port = 80
    }
  }
}