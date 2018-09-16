resource "google_container_node_pool" "np" {
  name       = "production-node-pool"
  zone       = "europe-west3-a"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    machine_type = "n1-highcpu-2"

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }
}

resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  zone               = "europe-west3-a"

  network = "default"

  master_auth {
    username = "${var.linux_admin_username}"
    password = "${var.linux_admin_password}"
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }
}