resource "google_service_account" "dashboard-service" {
  display_name = "dashboard-service"
  account_id = "dashboard-service"
}

resource "google_service_account" "auth-service" {
  display_name = "auth-service"
  account_id = "auth-service"
}

resource "google_service_account" "cloud-sql-proxy" {
  display_name = "cloud-sql-proxy"
  account_id = "cloud-sql-proxy"
}
