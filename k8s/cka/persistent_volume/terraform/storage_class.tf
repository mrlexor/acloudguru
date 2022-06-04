resource "kubernetes_storage_class" "main" {
  metadata {
    name = "localdisk"
  }
  storage_provisioner = "kubernetes.io/no-provisioner"
  allow_volume_expansion = true
}