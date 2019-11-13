resource "kubernetes_deployment" "dashboard-service" {
  metadata {
    name = "dashboard-service"
  }
  spec {
    selector {
      match_labels = {
        app = "dashboard-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "dashboard-service"
        }
      }
      spec {
        volume {
          name = "google-cloud-key"
          secret {
            secret_name = "google-application-credentials"
          }
        }
        container {
          image = "triangl-dashboard-service:latest"
          image_pull_policy = "Never"
          name  = "dashboard-service"
          volume_mount {
            mount_path = "/var/secrets/google"
            name = "google-cloud-key"
          }
          env {
            name = "GOOGLE_APPLICATION_CREDENTIALS"
            value = "/var/secrets/google/key.json"
          }
          env {
            name = "SPRING_CLOUD_GCP_SQL_DATABASE_NAME"
            value = "serving-prod"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "dashboard-service" {
  metadata {
    name = "dashboard-service"
  }
  spec {
    selector = {
      app = "dashboard-service"
    }
    port {
      protocol = "TCP"
      port = 8080
      target_port = 8080
    }
  }
}
