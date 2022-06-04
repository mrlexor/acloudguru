resource "kubernetes_pod" "main" {
  metadata {
    name = "maintenance-pod"
  }
  spec {
    container {
      name = "busybox1"
      image = "busybox"
      command = ["sh", "-c", "while true; do echo Success! >> /output/output.txt; sleep 5; done"]
      volume_mount {
        mount_path = "/output"
        name = "shared-vol"
      }
    }
    container {
      name = "busybox2"
      image = "busybox"
      command = ["sh", "-c", "while true; do cat /input/output.txt; sleep 5; done"]
      volume_mount {
        mount_path = "/input"
        name = "shared-vol"
      }
    }
    volume {
      name = "shared-vol"
      empty_dir {}
    }
  }
}