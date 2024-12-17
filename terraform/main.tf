locals {
  project = var.GCP_PROJECT_ID
  sysdig_secure_url = var.SYSDIG_SECURE_ENDPOINT_URL
  sysdig_secure_api_token = SYSDIG_SECURE_API_TOKEN
  gcp_region = var.GCP_REGION
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

terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~>1.42"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = local.sysdig_secure_url
  sysdig_secure_api_token = local.sysdig_secure_api_token
}

provider "google" {
  project = local.project
  region  = local.gcp_region
}

module "onboarding" {
  source     = "sysdiglabs/secure/google//modules/onboarding"
  version    = "~>0.3"
  project_id = local.project
}

module "config-posture" {
  source                   = "sysdiglabs/secure/google//modules/config-posture"
  version                  = "~>0.3"
  project_id               = module.onboarding.project_id
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
}

resource "sysdig_secure_cloud_auth_account_feature" "config_posture" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_CONFIG_POSTURE"
  enabled    = true
  components = [module.config-posture.service_principal_component_id]
  depends_on = [module.config-posture]
}