module "pub-sub" {
  source                   = "sysdiglabs/secure/google//modules/integrations/pub-sub"
  version                  = "~>0.3"
  project_id               = module.onboarding.project_id
  sysdig_secure_account_id = module.onboarding.sysdig_secure_account_id
  ingestion_sink_filter = [
    {
        (protoPayload.serviceName = "monitoring.googleapis.com" AND
            protoPayload.methodName:(
                "google.monitoring.v3.AlertPolicyService.CreateAlertPolicy" OR
                "google.monitoring.v3.AlertPolicyService.DeleteAlertPolicy" OR 
                "google.monitoring.v3.AlertPolicyService.UpdateAlertPolicy" OR
                "google.monitoring.dashboard.v1.DashboardsService" OR
                "google.monitoring.metricsscope.v1.MetricsScopes" OR
                "google.monitoring.v3.GroupService" OR
                "google.monitoring.v3.NotificationChannelService" OR
                "google.monitoring.v3.ServiceMonitoringService" OR
                "google.monitoring.v3.SnoozeService" OR
                "google.monitoring.v3.UptimeCheckService"
            )
        )　OR
        (protoPayload.serviceName = "compute.googleapis.com" AND
            protoPayload.methodName:(
                "compute.instances.get" OR
                "compute.instances.insert" OR
                "compute.instances.delete" OR
                "compute.instances.setMetadata" OR
                "compute.instances.updateShieldedInstanceConfig" OR
                "compute.firewalls.list" OR
                "compute.firewalls.update" OR
                "compute.firewalls.patch" OR
                "compute.firewalls.insert" OR
                "compute.firewalls.delete" OR
                "compute.projects.setCommonInstanceMetadata" OR
                "compute.networks.addPeering" OR
                "compute.networks.delete" OR
                "compute.networks.insert" OR
                "compute.networks.patch" OR
                "compute.networks.removePeering" OR
                "compute.networks.vpnTunnels.insert" OR
                "compute.networks.vpnTunnels.delete" OR
                "compute.subnetworks.patch" OR
                "compute.projects.setCommonInstanceMetadata" OR
                "compute.routes.insert" OR
                "compute.routers.delete"
            )
        ) OR
        (protoPayload.serviceName = "storage.googleapis.com" AND
            protoPayload.methodName:(                
                "storage.buckets.create" OR
                "storage.buckets.delete" OR
                "storage.buckets.list" OR
                "storage.buckets.update" OR
                "storage.objects.list" OR
                "storage.setIamPermissions"
            )
        ) OR
        (protoPayload.serviceName = "container.googleapis.com" AND
            protoPayload.methodName:(
                ".ClusterManager.DeleteCluster" OR
                ".ClusterManager.DeleteNodePool" OR
                ".DeleteRole"
            )
        ) OR
        (protoPayload.serviceName = "dns.googleapis.com" AND
            protoPayload.methodName:(
                "dns.changes.create" OR
                "dns.managedZones.create" OR
                "dns.managedZones.delete" OR
                "dns.managedZones.patch" OR
                "dns.resourceRecordSets.delete" OR
                "dns.resourceRecordSets.update"
            )
        ) OR
        (protoPayload.serviceName = "ids.googleapis.com" OR
            "loadbalancing.googleapis.com" OR
            "run.googleapis.com" OR
            "appengine.googleapis.com" OR
            "apikeys.googleapis.com" OR
            "cloudfunctions.googleapis.com" OR
            "dlp.googleapis.com" OR
            "cloudkms.googleapis.com" OR
            "cloudsql.googleapis.com" OR
            "cloudresourcemanager.googleapis.com" OR
            "iam.googleapis.com" OR
            "serviceusage.googleapis.com"
        )
    }
  ]
}
