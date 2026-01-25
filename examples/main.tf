terraform {
  required_version = ">= 1.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

module "codecarbon" {
  source = "../"

  enabled   = true
  namespace = "codecarbon"
  name      = "codecarbon"

  api_url       = "https://api.codecarbon.io"
  experiment_id = "your-experiment-id"
  api_key       = "your-api-key"
}
