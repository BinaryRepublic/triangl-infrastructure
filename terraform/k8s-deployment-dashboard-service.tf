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
            secret_name = "gcp-credentials-dashboard-service"
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
          env {
            name = "SENTRY_DSN"
            value = "https://cb310c54ec8b4a8bb8b507133c0b4cab@sentry.io/1818909"
          }
          resources {
            requests {
              cpu = "300m"
              memory = "512Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/actuator/info"
              port = "8080"
            }
            initial_delay_seconds = 120
            timeout_seconds = 2
            period_seconds = 5
            failure_threshold = 2
          }
          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = "8080"
            }
            initial_delay_seconds = 120
            timeout_seconds = 2
            period_seconds = 5
            failure_threshold = 2
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
