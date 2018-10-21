resource "google_pubsub_topic" "ingestion-prod" {
  name = "ingestion-prod"
}

resource "google_pubsub_topic" "ingestion-staging" {
  name = "ingestion-staging"
}
