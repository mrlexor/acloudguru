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

      volume_mount {
        mount_path = "/etc/nginx/conf"
        name       = "htpasswd-volume"
      }
    }

    volume {
      name = "htpasswd-volume"
      secret {
        secret_name = "nginx-htpasswd"
      }
    }
  }
}