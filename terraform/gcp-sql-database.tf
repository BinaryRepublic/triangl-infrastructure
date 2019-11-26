resource "google_sql_database_instance" "analyzing" {
  name = "analyzing"
  region = "europe-west3"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "serving-prod" {
  name      = "serving-prod"
  instance  = google_sql_database_instance.analyzing.name
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_database" "auth" {
  name      = "auth"
  instance  = google_sql_database_instance.analyzing.name
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_database" "dashboard-utils" {
  name      = "dashboard-utils"
  instance  = google_sql_database_instance.analyzing.name
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_user" "processing-pipeline" {
  instance = google_sql_database_instance.analyzing.name
  name     = "processing-pipeline"
  password = "initial-tUeHAaXaTzv8qenGEbwm"
}

resource "google_sql_user" "dashboard-service" {
  instance = google_sql_database_instance.analyzing.name
  name     = "dashboard-service"
  password = "initial-qenGEbtUeHAaXaTzv8wm"
}

resource "google_sql_user" "auth-service" {
  instance = google_sql_database_instance.analyzing.name
  name     = "auth-service"
  password = "initial-aXatUeHATzv8qenGEbwm"
}
