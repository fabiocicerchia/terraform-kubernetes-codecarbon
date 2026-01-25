locals {
  # Read the YAML file directly
  manifest_content = file("${path.module}/codecarbon-daemonset.yaml")

  # Split manifest into separate resources with kind+name as key
  manifests = {
    for doc in split("---", local.manifest_content) :
    "${yamldecode(doc).kind}-${yamldecode(doc).metadata.name}" => yamldecode(doc)
    if trimspace(doc) != ""
  }

  # Extract the original DaemonSet and Secret for easier reference
  daemonset_key = [for k in keys(local.manifests) : k if startswith(k, "DaemonSet-")][0]
  daemonset     = local.manifests[local.daemonset_key]
  secret_key    = [for k in keys(local.manifests) : k if startswith(k, "Secret-")][0]
  secret        = local.manifests[local.secret_key]

  # Build CodeCarbon configuration file content
  codecarbon_config = <<-EOT
    [codecarbon]
    api_endpoint = ${var.api_endpoint}
    organization_id = ${var.organization_id}
    project_id = ${var.project_id}
    experiment_id = ${var.experiment_id}
    api_key = ${var.api_key}
  EOT

  # Updated Secret with configuration
  updated_secret = merge(local.secret, {
    metadata = merge(local.secret.metadata, {
      namespace = var.namespace
    })
    stringData = {
      ".codecarbon.config" = local.codecarbon_config
    }
  })

  # Updated DaemonSet with variable overrides
  updated_daemonset = merge(local.daemonset, {
    metadata = merge(local.daemonset.metadata, {
      namespace = var.namespace
      name      = var.name
    })
    spec = merge(local.daemonset.spec, {
      selector = merge(local.daemonset.spec.selector, {
        matchLabels = merge(local.daemonset.spec.selector.matchLabels, {
          "app.kubernetes.io/name"     = var.name
          "app.kubernetes.io/instance" = var.name
        })
      })
      template = merge(local.daemonset.spec.template, {
        metadata = merge(local.daemonset.spec.template.metadata, {
          labels = merge(local.daemonset.spec.template.metadata.labels, {
            "app.kubernetes.io/name"     = var.name
            "app.kubernetes.io/instance" = var.name
          })
        })
        spec = merge(local.daemonset.spec.template.spec, {
          containers = [
            merge(local.daemonset.spec.template.spec.containers[0], {
              name  = var.name
              image = var.image
            })
          ]
        })
      })
    })
  })

  # Updated namespace
  updated_namespace = merge(local.manifests["Namespace-codecarbon"], {
    metadata = merge(local.manifests["Namespace-codecarbon"].metadata, {
      name = var.namespace
    })
  })

  # Final manifests with all updates applied
  final_manifests = merge(
    {
      "Namespace-${var.namespace}" = local.updated_namespace
    },
    {
      "${local.secret_key}" = local.updated_secret
    },
    {
      "${local.daemonset_key}" = local.updated_daemonset
    }
  )
}

resource "kubectl_manifest" "codecarbon" {
  for_each = var.enabled ? local.final_manifests : tomap({})

  yaml_body = yamlencode(each.value)

  wait             = true
  wait_for_rollout = true

  server_side_apply = true
  force_conflicts   = true
}
