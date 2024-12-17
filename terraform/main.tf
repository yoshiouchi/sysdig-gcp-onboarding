provider "google" {
  project = var.GCP_PROJECT_ID
  region  = var.GCP_REGION
}

module "project-posture" {
  source               = "sysdiglabs/secure/google//modules/services/service-principal"
  project_id           = var.GCP_PROJECT_ID
  service_account_name = "sysdig-secure-lv7z"
}

module "single-project-threat-detection" {
  source        = "sysdiglabs/secure/google//modules/services/webhook-datasource"
  project_id    = var.GCP_PROJECT_ID
  push_endpoint = format("%s/api/cloudingestion/gcp/v2/d11c4922-26b2-41c8-8e7c-751486c48f9b", var.SYSDIG_SECURE_ENDPOINT_URL)
  external_id   = "31063ec668b33ff8512d6952a1bf807e"
  exclude_logs_filter = [
    {
      name        = "exclude_services"
      description = "Exclude logs for specified services to reduce unnecessary ingestion"
      filter      = <<EOF
      protoPayload.serviceName = "k8s.io" OR
      protoPayload.serviceName = "bigquery.googleapis.com" OR
      protoPayload.serviceName = "iamcredentials.googleapis.com" OR
      protoPayload.serviceName = "artifactregistry.googleapis.com" OR
      protoPayload.serviceName = "containeranalysis.googleapis.com" OR
      protoPayload.serviceName = "secretmanager.googleapis.com" OR
      protoPayload.serviceName = "sts.googleapis.com" OR
      protoPayload.serviceName = "trafficdirector.googleapis.com" OR
      protoPayload.serviceName = "pubsub.googleapis.com" OR
      protoPayload.serviceName = "cloudbilling.googleapis.com" OR
      protoPayload.serviceName = "cloudasset.googleapis.com" OR
      protoPayload.serviceName = "redis.googleapis.com" OR
      protoPayload.serviceName = "nftest-cloudasset.sandbox.googleapis.com" OR
      protoPayload.serviceName = "orgpolicy.googleapis.com" OR
      protoPayload.serviceName = "datamigration.googleapis.com" OR
      protoPayload.serviceName = "gkehub.googleapis.com" OR
      protoPayload.serviceName = "websecurityscanner.googleapis.com" OR
      protoPayload.serviceName = "clouderrorreporting.googleapis.com" OR
      protoPayload.serviceName = "securitycenter.googleapis.com" OR
      protoPayload.serviceName = "iap.googleapis.com" OR
      protoPayload.serviceName = "certificatemanager.googleapis.com" OR
      protoPayload.serviceName = "cloudbuild.googleapis.com" OR
      protoPayload.serviceName = "servicehealth.googleapis.com" OR
      protoPayload.serviceName = "oslogin.googleapis.com" OR
      protoPayload.serviceName = "cloudscheduler.googleapis.com" OR
      protoPayload.serviceName = "cloudcommerceconsumerprocurement.googleapis.com" OR
      protoPayload.serviceName = "cloudaicompanion.googleapis.com" OR
      protoPayload.serviceName = "vpcaccess.googleapis.com" OR
      protoPayload.serviceName = "storagetransfer.googleapis.com" OR
      protoPayload.serviceName = "commerceorggovernance.googleapis.com" OR
      protoPayload.serviceName = "observability.googleapis.com" OR
      protoPayload.serviceName = "osconfig.googleapis.com" OR
      protoPayload.serviceName = "deploymentmanager.googleapis.com" OR
      protoPayload.serviceName = "networkservices.googleapis.com" OR
      protoPayload.serviceName = "cloudtrace.googleapis.com" OR
      protoPayload.serviceName = "networkconnectivity.googleapis.com" OR
      protoPayload.serviceName = "firebase.googleapis.com" OR
      protoPayload.serviceName = "cloudquotas.googleapis.com" OR
      protoPayload.serviceName = "networkmanagement.googleapis.com" OR
      protoPayload.serviceName = "dataplex.googleapis.com" OR
      protoPayload.serviceName = "privilegedaccessmanager.googleapis.com" OR
      protoPayload.serviceName = "networksecurity.googleapis.com" OR
      protoPayload.serviceName = "securitycentermanagement.googleapis.com" OR
      protoPayload.serviceName = "eventarc.googleapis.com" OR
      protoPayload.serviceName = "dataflow.googleapis.com" OR
      protoPayload.serviceName = "auditmanager.googleapis.com"
      EOF
    }
  ]
}


module "vm-host-scan" {
	source			= "sysdiglabs/secure/google//modules/services/agentless-scan"
	project_id		= var.GCP_PROJECT_ID
	worker_identity	= "agentless-worker-sa@prod-sysdig-agentless.iam.gserviceaccount.com"
	sysdig_backend	= "263844535661"
}
terraform {

  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = "~> 1.28.5"
    }
  }
}

provider "sysdig" {
  sysdig_secure_url       = var.SYSDIG_SECURE_ENDPOINT_URL
  sysdig_secure_api_token = var.SYSDIG_SECURE_API_TOKEN
}

resource "sysdig_secure_cloud_auth_account" "gcp_project" {
  enabled       = true
  provider_id   = var.GCP_PROJECT_ID
  provider_type = "PROVIDER_GCP"

  feature {

    secure_threat_detection {
      enabled    = true
      components = ["COMPONENT_WEBHOOK_DATASOURCE/secure-runtime"]
    }

    secure_identity_entitlement {
      enabled    = true
      components = ["COMPONENT_WEBHOOK_DATASOURCE/secure-runtime"]
    }

    secure_config_posture {
      enabled    = true
      components = ["COMPONENT_SERVICE_PRINCIPAL/secure-posture"]
    }

    secure_agentless_scanning {
      enabled    = true
      components = ["COMPONENT_SERVICE_PRINCIPAL/secure-scanning"]
    }
  }
  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-posture"
    service_principal_metadata = jsonencode({
      gcp = {
        key = module.project-posture.service_account_key
      }
    })
  }
  component {
    type     = "COMPONENT_WEBHOOK_DATASOURCE"
    instance = "secure-runtime"
    webhook_datasource_metadata = jsonencode({
      gcp = {
        webhook_datasource = {
          pubsub_topic_name      = module.single-project-threat-detection.ingestion_pubsub_topic_name
          sink_name              = module.single-project-threat-detection.ingestion_sink_name
          push_subscription_name = module.single-project-threat-detection.ingestion_push_subscription_name
          push_endpoint          = module.single-project-threat-detection.push_endpoint
          routing_key            = "d11c4922-26b2-41c8-8e7c-751486c48f9b"
        }
        service_principal = {
          workload_identity_federation = {
            pool_id          = module.single-project-threat-detection.workload_identity_pool_id
            pool_provider_id = module.single-project-threat-detection.workload_identity_pool_provider_id
            project_number   = module.single-project-threat-detection.workload_identity_project_number
          }
          email = module.single-project-threat-detection.service_account_email
        }
      }
    })
  }
  component {
    type     = "COMPONENT_SERVICE_PRINCIPAL"
    instance = "secure-scanning"
    service_principal_metadata = jsonencode({
      gcp = {
        workload_identity_federation = {
          pool_provider_id = module.vm-host-scan.workload_identity_pool_provider
        }
        email = module.vm-host-scan.controller_service_account
      }
    })
  }
  depends_on = [module.project-posture, module.single-project-threat-detection, module.vm-host-scan]
}