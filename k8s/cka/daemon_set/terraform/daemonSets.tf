resource "kubernetes_daemonset" "main" {
  metadata {
    name = "busybox"
  }
  spec {
    selector {
      match_labels = {
        app = "busybox"
      }
    }
    template {
      metadata {
        labels = {
          app = "busybox"
        }
      }
      spec {
        container {
          name    = "busybox"
          image   = "busybox:1.27"
          command = ["sh", "-c", "while true; do rm -rf /tmp/*; sleep 60; done"]
        }
      }
    }
  }
}