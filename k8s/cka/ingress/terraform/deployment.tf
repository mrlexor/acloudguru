resource "kubernetes_deployment" "main" {
  metadata {
    name = "web-auth"
    namespace = "default"
  }
  spec {
    progress_deadline_seconds = 600
    replicas = 2
    revision_history_limit = 10
    selector {
      match_labels = {
        app = "web-auth"
      }
    }
    strategy {
      rolling_update {
        max_surge = 25
        max_unavailable = 25
      }
      type = "RollingUpdate"
    }
    template {
      metadata {
        labels = {
          app = "web-auth"
        }
      }
      spec {
        container {
          name    = "nginx"
          image   = "nginx:1.19.1"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 80
            protocol = "TCP"
          }
        }
      }
    }
  }
}