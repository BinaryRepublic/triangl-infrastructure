resource "google_project_iam_binding" "cloud-sql-users" {
  depends_on = [
    google_service_account.dashboard-service,
    google_service_account.auth-service
  ]
  role    = "roles/cloudsql.client"
  members  = [
    "serviceAccount:dashboard-service@triangl.iam.gserviceaccount.com",
    "serviceAccount:auth-service@triangl.iam.gserviceaccount.com",
    "serviceAccount:cloud-sql-proxy@triangl.iam.gserviceaccount.com"
  ]
}
