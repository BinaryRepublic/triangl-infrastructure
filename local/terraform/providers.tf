provider "google" {
  project     = "triangl"
  region      = "europe-west3"
}

provider "kubernetes" {
  config_context_auth_info = "triangl-prod"
  config_context_cluster   = "triangl-prod"
}
