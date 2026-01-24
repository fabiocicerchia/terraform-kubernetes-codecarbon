# Compatible with Terraform >= 1.0 and OpenTofu >= 1.6
terraform {
  required_version = ">= 1.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}
