locals {
  project = var.GCP_PROJECT_ID
  services = [
    "sts.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudidentity.googleapis.com",
    "admin.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

provider "google" {
  project     = local.project
  region      = var.GCP_REGION
}

resource "google_project_service" "enable_cspm_apis" {
  project  = local.project

  for_each = toset(local.services)
  service = each.value
  disable_on_destroy = false
}

output "enabled_projects" {
  value = distinct([for service in local.services : google_project_service.enable_cspm_apis[service].project])
}
output "enabled_services" {
  value = [for service in local.services : google_project_service.enable_cspm_apis[service].service]
}