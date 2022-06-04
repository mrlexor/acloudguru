resource "kubernetes_deployment" "user_db" {
  metadata {
    name = "user-db"
    namespace = "default"
  }
  spec {
    progress_deadline_seconds = 600
    replicas = 2
    revision_history_limit = 10
    selector {
      match_labels = {
        app = "user-db"
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
          app = "user-db"
        }
      }
      spec {
        container {
          name    = "web-server"
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

resource "kubernetes_deployment" "web_frontend" {
  metadata {
    name = "web-frontend"
    namespace = "default"
  }
  spec {
    progress_deadline_seconds = 600
    replicas = 2
    revision_history_limit = 10
    selector {
      match_labels = {
        app = "web-frontend"
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
          app = "web-frontend"
        }
      }
      spec {
        container {
          name    = "web-server"
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