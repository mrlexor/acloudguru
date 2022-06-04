resource "kubernetes_persistent_volume" "main" {
  metadata {
    name = "host-pv"
  }
  spec {
    persistent_volume_source {
      host_path {
        path = "/tmp"
      }
    }
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Recycle"
    storage_class_name = "localdisk"
  }
  
  depends_on = [
    kubernetes_storage_class.main
  ]
}