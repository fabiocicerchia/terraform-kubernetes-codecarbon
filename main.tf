locals {
  # Read the YAML file directly
  manifest_content = file("${path.module}/codecarbon-daemonset.yaml")

  # Split manifest into separate resources with kind+name as key
  manifests = {
    for doc in split("---", local.manifest_content) :
    "${yamldecode(doc).kind}-${yamldecode(doc).metadata.name}" => yamldecode(doc)
    if trimspace(doc) != ""
  }

  # Extract the original DaemonSet for easier reference
  daemonset_key = [for k in keys(local.manifests) : k if startswith(k, "DaemonSet-")][0]
  daemonset     = local.manifests[local.daemonset_key]

  # Build updated environment variables
  updated_env = concat(
    [
      for env in local.daemonset.spec.template.spec.containers[0].env :
      env.name == "CODECARBON_API_URL" ? merge(env, { value = var.api_url }) :
      env.name == "CODECARBON_EXPERIMENT_ID" ? merge(env, { value = var.experiment_id }) :
      env.name == "CODECARBON_API_KEY" ? merge(env, { value = var.api_key }) :
      env
    ],
    # Only add env vars if they don't already exist and have non-empty values
    !contains([for env in local.daemonset.spec.template.spec.containers[0].env : env.name], "CODECARBON_API_URL") && var.api_url != "" ? [{
      name  = "CODECARBON_API_URL"
      value = var.api_url
    }] : [],
    !contains([for env in local.daemonset.spec.template.spec.containers[0].env : env.name], "CODECARBON_EXPERIMENT_ID") && var.experiment_id != "" ? [{
      name  = "CODECARBON_EXPERIMENT_ID"
      value = var.experiment_id
    }] : [],
    !contains([for env in local.daemonset.spec.template.spec.containers[0].env : env.name], "CODECARBON_API_KEY") && var.api_key != "" ? [{
      name  = "CODECARBON_API_KEY"
      value = var.api_key
    }] : []
  )

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
              env   = local.updated_env
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
