/*
  THIS DEPLOYMENT WAS JUST ADDED TO CONNECT TO GCLOUD SQL FROM A LOCAL
  MINIKUBE CLUSTER. THIS SHOULD BE REMOVED WHEN RUNNING THE CLUSTER ON
  GCP.
*/

resource "kubernetes_deployment" "cloud-sql-proxy" {
  metadata {
    name = "cloud-sql-proxy"
  }
  spec {
    selector {
      match_labels = {
        app = "cloud-sql-proxy"
      }
    }
    template {
      metadata {
        labels = {
          app = "cloud-sql-proxy"
        }
      }
      spec {
        volume {
          name = "google-cloud-key"
          secret {
            secret_name = "gcp-credentials-cloud-sql-proxy"
          }
        }
        container {
          image = "gcr.io/cloudsql-docker/gce-proxy:1.12"
          name  = "cloud-sql-proxy"
          volume_mount {
            mount_path = "/var/secrets/google"
            name = "google-cloud-key"
          }
          command = ["/cloud_sql_proxy"]
          args = [
            "-instances", "triangl:europe-west3:analyzing=tcp:0.0.0.0:3306",
            "-credential_file", "/var/secrets/google/key.json"
          ]
        }
      }
    }
  }
}

resource "kubernetes_service" "cloud-sql-proxy" {
  metadata {
    name = "cloud-sql-proxy"
  }
  spec {
    selector = {
      app = "cloud-sql-proxy"
    }
    port {
      protocol = "TCP"
      port = 3306
      target_port = 3306
    }
  }
}
