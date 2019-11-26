resource "kubernetes_deployment" "customer-service" {
  metadata {
    name = "customer-service"
  }
  spec {
    selector {
      match_labels = {
        app = "customer-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "customer-service"
        }
      }
      spec {
        volume {
          name = "google-cloud-key"
          secret {
            secret_name = "gcp-credentials-customer-service"
          }
        }
        container {
          image = "triangl-customer-service:latest"
          image_pull_policy = "Never"
          name  = "customer-service"
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
            name = "SENTRY_DSN"
            value = "https://c72d446aead4482f9e0f39c18a034bda@sentry.io/1314460"
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

resource "kubernetes_service" "customer-service" {
  metadata {
    name = "customer-service"
  }
  spec {
    selector = {
      app = "customer-service"
    }
    port {
      protocol = "TCP"
      port = 8080
      target_port = 8080
    }
  }
}
