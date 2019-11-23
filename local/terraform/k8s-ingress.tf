resource "kubernetes_ingress" "app-ingress" {
  metadata {
    name = "app-ingress"
  }
  spec {
    rule {
      host = "app.triangl.local.io"
      http {
        path {
          path = "/"
          backend {
            service_name = "dashboard"
            service_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "api-ingress" {
  metadata {
    name = "api-ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
    }
  }
  spec {
    rule {
      host = "api.triangl.local.io"
      http {
        path {
          path = "/customer-service(/|$)(.*)"
          backend {
            service_name = "customer-service"
            service_port = 8080
          }
        }
        path {
          path = "/tracking-ingestion-service(/|$)(.*)"
          backend {
            service_name = "tracking-ingestion-service"
            service_port = 8080
          }
        }
        path {
          path = "/dashboard-service(/|$)(.*)"
          backend {
            service_name = "dashboard-service"
            service_port = 8080
          }
        }
      }
    }
  }
}
