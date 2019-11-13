resource "google_service_account_key" "dashboard-service-key" {
  depends_on = [google_service_account.dashboard-service]
  service_account_id = "dashboard-service"
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "google-application-credentials"
  }
  data = {
    "key.json" = base64decode(google_service_account_key.dashboard-service-key.private_key)
  }
}
