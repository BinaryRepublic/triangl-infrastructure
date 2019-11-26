resource "google_service_account" "dashboard-service" {
  display_name = "dashboard-service"
  account_id = "dashboard-service"
}

resource "google_service_account" "auth-service" {
  display_name = "auth-service"
  account_id = "auth-service"
}

resource "google_service_account" "customer-service" {
  display_name = "customer-service"
  account_id = "customer-service"
}

resource "google_service_account" "tracking-ingestion-service" {
  display_name = "tracking-ingestion-service"
  account_id = "tracking-ingestion-service"
}

resource "google_service_account" "processing-pipeline" {
  display_name = "processing-pipeline"
  account_id = "processing-pipeline"
}
