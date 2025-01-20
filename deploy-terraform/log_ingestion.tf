module "pub-sub" {
  source                   = "sysdiglabs/secure/google//modules/integrations/pub-sub"
  version                  = "~>0.3"
  project_id               = module.onboarding.project_id
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
  exclude_logs_filter = [
    {
      name = "k8s.io"
      description = "Exclude k8s.io service"
      filter = "protoPayload.serviceName = \"k8s.io\""
    },
    {
      name = "monitoring.googleapis.com"
      description = "Exclude MetricService, PrometheusUpstream and QueryService from monitoring.googleapis.com"
      filter = <<EOT
        protoPayload.serviceName = "monitoring.googleapis.com" AND
          protoPayload.methodName:(
            "google.monitoring.v3.MetricService" OR
            "google.monitoring.prometheus.v1.PrometheusUpstream" OR
            "google.monitoring.v3.QueryService"
          )
      EOT
    },
    {
      name = "compute.googleapis.com"
      description = "Exclude services/methods from compute.googleapis.com"
      filter = <<EOT
        protoPayload.serviceName = "compute.googleapis.com" AND
          protoPayload.methodName:(
            "compute.addresses" OR
            "compute.firewalls.get" OR
            "compute.forwardingRules.get" OR
            "compute.instances.list" OR
            "compute.instancesGroupManagers" OR
            "compute.regionBackendServices.get" OR
            "compute.regionBackendServices.list" OR
            "compute.regionBackendServices.getHealth" OR
            "compute.regionOperations.wait" OR
            "v1.compute.instances.aggregatedList" OR
            "v1.compute.healthChecks.get" OR
            "v1.compute.disks.list" OR
            "v1.compute.disks.aggregatedList" OR
            "v1.compute.backendServices.get" OR
            "v1.compute.backendServices.getHealth" OR
            "beta.compute.backendServices.get"
          )
      EOT
    },
    {
      name = "logging.googleapis.com"
      description = "Exclude LoggingServiceV2.ListLogEntries from logging.googleapis.com"
      filter = <<EOT
        protoPayload.serviceName = "logging.googleapis.com" AND
          protoPayload.methodName:(
            "google.logging.v2.LoggingServiceV2.ListLogEntries"
          )
      EOT
    }
  ]
}

resource "sysdig_secure_cloud_auth_account_feature" "threat_detection" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_THREAT_DETECTION"
  enabled    = true
  components = [module.pub-sub.pubsub_datasource_component_id]
  depends_on = [module.pub-sub]
}

resource "sysdig_secure_cloud_auth_account_feature" "identity_entitlement" {
  account_id = module.onboarding.sysdig_secure_account_id
  type       = "FEATURE_SECURE_IDENTITY_ENTITLEMENT"
  enabled    = true
  components = [module.pub-sub.pubsub_datasource_component_id]
  depends_on = [sysdig_secure_cloud_auth_account_feature.config_posture, module.pub-sub]
}