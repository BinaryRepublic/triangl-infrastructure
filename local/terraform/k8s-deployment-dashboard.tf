resource "kubernetes_deployment" "dashboard" {
  metadata {
    name = "dashboard"
  }
  spec {
    selector {
      match_labels = {
        app = "dashboard"
      }
    }
    template {
      metadata {
        labels = {
          app = "dashboard"
        }
      }
      spec {
        container {
          image = "triangl-dashboard:latest"
          image_pull_policy = "Never"
          name  = "dashboard"
        }
      }
    }
  }
}

resource "kubernetes_service" "dashboard" {
  metadata {
    name = "dashboard"
  }
  spec {
    selector = {
      app = "dashboard"
    }
    port {
      protocol = "TCP"
      port = 80
      target_port = 80
    }
  }
}
