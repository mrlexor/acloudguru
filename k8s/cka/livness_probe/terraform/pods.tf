resource "kubernetes_pod" "main" {
  metadata {
    name = "nginx"
  }

  spec {
    container {
      image             = "nginx:1.19.1"
      name              = "nginx"
      image_pull_policy = "IfNotPresent"

      port {
        container_port = 80
      }

      liveness_probe {

        http_get {
          path = "/"
          port = "80"
        }

        initial_delay_seconds = 5
        period_seconds        = 5
      }
    }
  }
}