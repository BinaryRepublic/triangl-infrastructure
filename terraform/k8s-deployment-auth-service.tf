resource "kubernetes_deployment" "auth-service" {
  metadata {
    name = "auth-service"
  }
  spec {
    selector {
      match_labels = {
        app = "auth-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "auth-service"
        }
      }
      spec {
        volume {
          name = "google-cloud-key"
          secret {
            secret_name = "gcp-credentials-auth-service"
          }
        }
        volume {
          name = "auth-jwt-keypair"
          secret {
            secret_name = "auth-jwt-keypair"
          }
        }
        container {
          image = "triangl-auth-service:latest"
          image_pull_policy = "Never"
          name  = "auth-service"
          volume_mount {
            mount_path = "/var/secrets/google"
            name = "google-cloud-key"
          }
          volume_mount {
            mount_path = "/var/secrets/jwt"
            name = "auth-jwt-keypair"
          }
          env {
            name = "JWT_KEYS_PATH"
            value = "/var/secrets/jwt"
          }
          env {
            name = "BASE_URL"
            value = "http://api.triangl.local.io/auth-service"
          }
          env {
            name = "SQL_HOST"
            value = "cloud-sql-proxy"
          }
          env {
            name = "SQL_USER"
            value_from {
              secret_key_ref {
                name = "auth-service-db-cred"
                key = "user"
              }
            }
          }
          env {
            name = "SQL_PASSWORD"
            value_from {
              secret_key_ref {
                name = "auth-service-db-cred"
                key = "password"
              }
            }
          }
          env {
            name = "SQL_DATABASE"
            value = "auth"
          }
          resources {
            requests {
              cpu = "300m"
              memory = "512Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/auth/.well-known/jwks.json"
              port = "3000"
            }
            initial_delay_seconds = 120
            timeout_seconds = 2
            period_seconds = 5
            failure_threshold = 2
          }
          readiness_probe {
            http_get {
              path = "/auth/.well-known/jwks.json"
              port = "3000"
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

resource "kubernetes_service" "auth-service" {
  metadata {
    name = "auth-service"
  }
  spec {
    selector = {
      app = "auth-service"
    }
    port {
      protocol = "TCP"
      port = 3000
      target_port = 3000
    }
  }
}
