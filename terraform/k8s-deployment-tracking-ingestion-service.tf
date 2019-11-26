resource "kubernetes_deployment" "tracking-ingestion-service" {
  metadata {
    name = "tracking-ingestion-service"
  }
  spec {
    selector {
      match_labels = {
        app = "tracking-ingestion-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "tracking-ingestion-service"
        }
      }
      spec {
        volume {
          name = "google-cloud-key"
          secret {
            secret_name = "gcp-credentials-tracking-ingestion-service"
          }
        }
        container {
          image = "triangl-tracking-ingestion-service:latest"
          image_pull_policy = "Never"
          name  = "tracking-ingestion-service"
          volume_mount {
            mount_path = "/var/secrets/google"
            name = "google-cloud-key"
          }
          env {
            name = "GOOGLE_APPLICATION_CREDENTIALS"
            value = "/var/secrets/google/key.json"
          }
          env {
            name = "PUBSUB_TOPICID"
            value = "ingestion-prod"
          }
          env {
            name = "MAC_SALT"
            value_from {
              secret_key_ref {
                name = "mac-hashing"
                key = "salt"
              }
            }
          }
          env {
            name = "MAC_PEPPER"
            value_from {
              secret_key_ref {
                name = "mac-hashing"
                key = "pepper"
              }
            }
          }
          env {
            name = "SENTRY_DSN"
            value = "https://c72d446aead4482f9e0f39c18a034bda@sentry.io/1318093"
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

resource "kubernetes_service" "tracking-ingestion-service" {
  metadata {
    name = "tracking-ingestion-service"
  }
  spec {
    selector = {
      app = "tracking-ingestion-service"
    }
    port {
      protocol = "TCP"
      port = 8080
      target_port = 8080
    }
  }
}
