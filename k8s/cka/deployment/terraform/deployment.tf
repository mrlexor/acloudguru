resource "kubernetes_deployment" "main" {
  metadata {
    name = "beebox-web"
    namespace = "default"
  }
  spec {
    progress_deadline_seconds = 600
    replicas = 3
    revision_history_limit = 10
    selector {
      match_labels = {
        app = "beebox-web"
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
          app = "beebox-web"
        }
      }
      spec {
        container {
          name    = "web-server"
          image   = "acgorg/beebox-web:1.0.1"
          image_pull_policy = "IfNotPresent"
          termination_message_path = "/dev/termination-log"
          termination_message_policy = "File"
          port {
            container_port = 80
            protocol = "TCP"
          }
        }
      }
    }
  }
}