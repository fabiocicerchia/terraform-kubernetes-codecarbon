module "codecarbon" {
  source = "../"

  enabled           = var.enabled
  namespace         = var.namespace
  create_namespace  = var.create_namespace
  name              = var.name
  image             = var.image
  api_url           = var.api_url
  experiment_id     = var.experiment_id
  api_key           = var.api_key
  extra_env         = var.extra_env
  labels            = var.labels
  resources         = var.resources
}
