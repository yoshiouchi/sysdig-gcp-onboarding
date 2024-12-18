locals {
  project = var.GCP_PROJECT_ID
  gcp_region = var.GCP_REGION
  services = [
    "pubsub.googleapis.com"
  ]
}

provider "google" {
  project     = local.project
  region      = local.gcp_region
}

resource "google_project_service" "enable_cdr_ciem_apis" {
  project  = local.project

  for_each = toset(local.services)
  service = each.value
  disable_on_destroy = false
}

output "enabled_projects" {
  value = distinct([for service in local.services : google_project_service.enable_cdr_ciem_apis[service].project])
}

output "enabled_services" {
  value = [for service in local.services : google_project_service.enable_cdr_ciem_apis[service].service]
}
