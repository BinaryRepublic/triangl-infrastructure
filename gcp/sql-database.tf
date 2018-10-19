resource "google_sql_database_instance" "analyzing" {
  name = "analyzing"
  region = "europe-west3"

  settings {
    tier = "db-f1-micro"
  }
}

//resource "google_sql_database" "serving" {
//  name      = "servingDB"
//  instance  = "${google_sql_database_instance.analyzing.name}"
//  charset   = "latin1"
//  collation = "latin1_swedish_ci"
//}

resource "google_sql_user" "users" {
  instance = "${google_sql_database_instance.analyzing.name}"
  name     = "root"
  password = "root"
}