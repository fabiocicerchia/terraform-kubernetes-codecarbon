output "namespace" {
  description = "The namespace where codecarbon is deployed"
  value       = var.namespace
}

output "daemonset_name" {
  description = "The name of the codecarbon DaemonSet"
  value       = var.enabled ? var.name : null
}

output "enabled" {
  description = "Whether codecarbon is enabled"
  value       = var.enabled
}

output "manifest_yaml" {
  description = "The rendered YAML manifest for codecarbon (can be used with kubectl apply)"
  value       = var.enabled ? local.manifest_content : null
}
