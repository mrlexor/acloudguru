resource "kubernetes_service" "cluster_ip" {
  metadata {
    name = "user-db-svc"
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "user-db"
    }
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }
  }
}

resource "kubernetes_service" "node_port" {
  metadata {
    name = "web-frontend-svc"
  }
  spec {
    type = "NodePort"
    selector = {
      app = "web-frontend"
    }
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
      node_port = 30080
    }
  }
}

