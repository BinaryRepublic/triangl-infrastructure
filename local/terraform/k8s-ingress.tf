resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$2"
    }
  }
  spec {
    rule {
      host = "triangl.local.io"
      http {
        path {
          path = "/(/|$)(.*)"
          backend {
            service_name = "dashboard"
            service_port = 80
          }
        }
        path {
          path = "/api/customer-service(/|$)(.*)"
          backend {
            service_name = "customer-service"
            service_port = 8080
          }
        }
        path {
          path = "/api/tracking-ingestion-service(/|$)(.*)"
          backend {
            service_name = "tracking-ingestion-service"
            service_port = 8080
          }
        }
        path {
          path = "/api/dashboard-service(/|$)(.*)"
          backend {
            service_name = "dashboard-service"
            service_port = 8080
          }
        }
      }
    }
  }
}
