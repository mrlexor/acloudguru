resource "kubernetes_pod" "main" {
  metadata {
    name = "pv-pod"
  }
  spec {
    container {
      name = "busybox"
			image = "busybox"
			command = ["sh", "-c", "while true; do echo Success2! >> /output/success.txt; sleep 5; done"] 
			volume_mount {
				mount_path = "/output"
				name = "pv-storage"
			}
    }
		volume {
			name = "pv-storage"
			persistent_volume_claim {
				claim_name = "host-pvc"
			}
		}
  }

	depends_on = [
		kubernetes_persistent_volume_claim.main
	]
}