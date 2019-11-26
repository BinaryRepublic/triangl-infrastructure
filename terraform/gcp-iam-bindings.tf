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

resource "google_project_iam_binding" "datastore-admin-user" {
  depends_on = [
    google_service_account.processing-pipeline,
    google_service_account.tracking-ingestion-service
  ]
  role    = "roles/datastore.indexAdmin"
  members  = [
    "serviceAccount:processing-pipeline@triangl.iam.gserviceaccount.com",
    "serviceAccount:tracking-ingestion-service@triangl.iam.gserviceaccount.com"
  ]
}

resource "google_project_iam_binding" "datastore-customer-user" {
  depends_on = [
    google_service_account.customer-service
  ]
  role    = "roles/datastore.indexAdmin;datastore.entities.Customer"
  members  = [
    "serviceAccount:customer-service@triangl.iam.gserviceaccount.com",
  ]
}
