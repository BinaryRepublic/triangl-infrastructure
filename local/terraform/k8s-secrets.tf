resource "google_service_account_key" "dashboard-service-key" {
  depends_on = [google_service_account.dashboard-service]
  service_account_id = "dashboard-service"
}

resource "kubernetes_secret" "gcp-credentials-dashboard-service" {
  metadata {
    name = "gcp-credentials-dashboard-service"
  }
  data = {
    "key.json" = base64decode(google_service_account_key.dashboard-service-key.private_key)
  }
}

resource "google_service_account_key" "auth-service-key" {
  depends_on = [google_service_account.auth-service]
  service_account_id = "auth-service"
}

resource "kubernetes_secret" "gcp-credentials-auth-service" {
  metadata {
    name = "gcp-credentials-auth-service"
  }
  data = {
    "key.json" = base64decode(google_service_account_key.auth-service-key.private_key)
  }
}

resource "google_service_account_key" "cloud-sql-proxy-key" {
  depends_on = [google_service_account.cloud-sql-proxy]
  service_account_id = "cloud-sql-proxy"
}

resource "kubernetes_secret" "gcp-credentials-cloud-sql-proxy" {
  metadata {
    name = "gcp-credentials-cloud-sql-proxy"
  }
  data = {
    "key.json" = base64decode(google_service_account_key.cloud-sql-proxy-key.private_key)
  }
}
