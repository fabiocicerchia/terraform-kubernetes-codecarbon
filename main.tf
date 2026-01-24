locals {
  manifest_content = templatefile("${path.module}/codecarbon-daemonset.yaml.tpl", {
    name                      = var.name
    namespace                 = var.namespace
    image                     = var.image
    api_url                   = var.api_url
    experiment_id             = var.experiment_id
    api_key                   = var.api_key
    extra_env                 = var.extra_env
    resources_requests_cpu    = var.resources.requests.cpu
    resources_requests_memory = var.resources.requests.memory
    resources_limits_cpu      = var.resources.limits.cpu
    resources_limits_memory   = var.resources.limits.memory
  })

  # Split manifest into separate resources (namespace and daemonset)
  manifests = [for doc in split("---", local.manifest_content) : yamldecode(doc) if trimspace(doc) != ""]
}

resource "kubectl_manifest" "codecarbon" {
  count = var.enabled ? length(local.manifests) : 0

  yaml_body = yamlencode(local.manifests[count.index])

  wait             = true
  wait_for_rollout = true

  server_side_apply = true
  force_conflicts   = true
}
