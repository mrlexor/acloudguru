resource "kubernetes_secret" "main" {
  metadata {
    name = "nginx-htpasswd"
  }

  data = {
    htpasswd = "user:$apr1$.evqZD4l$QivvYrn.ZIyJ1WV0e.LlB0"
  }

  type = "generic"
}