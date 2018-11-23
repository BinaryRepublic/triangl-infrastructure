resource "google_sql_database_instance" "analyzing" {
  name = "analyzing"
  region = "europe-west3"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "serving-prod" {
  name      = "serving-prod"
  instance  = "${google_sql_database_instance.analyzing.name}"
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_database" "serving-staging" {
  name      = "serving-staging"
  instance  = "${google_sql_database_instance.analyzing.name}"
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_database" "dashboard-utils" {
  name      = "dashboard-utils"
  instance  = "${google_sql_database_instance.analyzing.name}"
  charset   = "latin1"
  collation = "latin1_swedish_ci"
}

resource "google_sql_user" "users" {
  instance = "${google_sql_database_instance.analyzing.name}"
  name     = "root"
  password = "root"
}