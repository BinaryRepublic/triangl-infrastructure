resource "kubernetes_deployment" "processing-pipeline" {
  metadata {
    name = "processing-pipeline"
  }
  spec {
    selector {
      match_labels = {
        app = "processing-pipeline"
      }
    }
    template {
      metadata {
        labels = {
          app = "processing-pipeline"
        }
      }
      spec {
        volume {
          name = "google-cloud-key"
          secret {
            secret_name = "gcp-credentials-processing-pipeline"
          }
        }
        container {
          image = "triangl-processing-pipeline:latest"
          image_pull_policy = "Never"
          name  = "processing-pipeline"
          volume_mount {
            mount_path = "/var/secrets/google"
            name = "google-cloud-key"
          }
          env {
            name = "GOOGLE_APPLICATION_CREDENTIALS"
            value = "/var/secrets/google/key.json"
          }
          env {
            name = "PROJECT_ID"
            value = "triangl-215714"
          }
          env {
            name = "PUBSUB_TOPIC"
            value = "ingestion-prod"
          }
          env {
            name = "PUBSUB_SUBSCRIPTION"
            value = "processing-pipeline-prod"
          }
          env {
            name = "JDBC_URL"
            value = "jdbc:mysql://google/serving-prod?cloudSqlInstance=triangl-215714:europe-west3:analyzing&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false"
          }
          env {
            name = "DB_USER"
            value_from {
              secret_key_ref {
                name = "processing-pipeline-db-cred"
                key = "user"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = "processing-pipeline-db-cred"
                key = "password"
              }
            }
          }
          env {
            name = "SENTRY_DSN"
            value = "https://4df769dbdaf447e6aa1a28dacdb067a1@sentry.io/1317883"
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

resource "kubernetes_service" "processing-pipeline" {
  metadata {
    name = "processing-pipeline"
  }
  spec {
    selector = {
      app = "processing-pipeline"
    }
    port {
      protocol = "TCP"
      port = 8080
      target_port = 8080
    }
  }
}
