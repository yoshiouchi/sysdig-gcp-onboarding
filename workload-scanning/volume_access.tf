locals {
  project = "sysdig-20240916"
  services = [
    "compute.googleapis.com"
  ]
}

provider "google" {
  project     = local.project
  region      = "us-west1"
}

resource "google_project_service" "enable_vm_apis" {
  project  = local.project

  for_each = toset(local.services)
  service = each.value
  disable_on_destroy = false
}

output "enabled_projects" {
  value = distinct([for service in local.services : google_project_service.enable_vm_apis[service].project])
}

output "enabled_services" {
  value = [for service in local.services : google_project_service.enable_vm_apis[service].service]
}