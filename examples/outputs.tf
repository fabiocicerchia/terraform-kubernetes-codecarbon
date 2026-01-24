output "namespace" {
  description = "The namespace where codecarbon is deployed"
  value       = module.codecarbon.namespace
}

output "daemonset_name" {
  description = "The name of the codecarbon DaemonSet"
  value       = module.codecarbon.daemonset_name
}

output "enabled" {
  description = "Whether codecarbon is enabled"
  value       = module.codecarbon.enabled
}
