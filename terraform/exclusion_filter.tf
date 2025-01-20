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
    }
  ]
}
