resource "kubernetes_service" "main" {
  metadata {
    name = "back-svc"
  }
  spec {
    selector = {
      app = "back-svc"
    }
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }
  }
}