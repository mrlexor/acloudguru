resource "kubernetes_persistent_volume_claim" "main" {
  metadata {
    name = "host-pvc"
  }
  spec {
    resources {
      requests = {
        storage = "100Mi"
      }
    }
		storage_class_name = "localdisk"
		access_modes = ["ReadWriteOnce"]
  }

	depends_on = [
		kubernetes_persistent_volume.main
	]
}