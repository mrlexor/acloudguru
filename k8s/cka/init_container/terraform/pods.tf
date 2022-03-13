resource "kubernetes_pod" "front" {
  metadata {
    name = "front"
  }

  spec {
    container {
      image             = "nginx:1.19.1"
      name              = "front"
      image_pull_policy = "IfNotPresent"
    }

    init_container {
      name    = "back-svc-check"
      image   = "busybox:1.27"
      command = [
        "sh",
        "-c",
        "until nslookup back-svc; do echo waiting for back-svc; sleep 2; done"
      ]
    }
  }
}

resource "kubernetes_pod" "back" {
  metadata {
    name = "back"
  }

  spec {
    container {
      image             = "nginx:1.19.1"
      name              = "back"
      image_pull_policy = "IfNotPresent"
    }
  }
}