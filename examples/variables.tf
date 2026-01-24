variable "enabled" {
  description = "Enable or disable the codecarbon DaemonSet"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the DaemonSet"
  type        = string
  default     = "codecarbon"
}

variable "namespace" {
  description = "Kubernetes namespace for codecarbon"
  type        = string
  default     = "codecarbon"
}

variable "image" {
  description = "Docker image for codecarbon"
  type        = string
  default     = "codecarbon/codecarbon:v2.4.1"
}

variable "api_url" {
  description = "CodeCarbon API URL for reporting emissions"
  type        = string
  default     = ""
}

variable "experiment_id" {
  description = "CodeCarbon experiment ID"
  type        = string
  default     = ""
}

variable "api_key" {
  description = "CodeCarbon API key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "extra_env" {
  description = "Additional environment variables"
  type        = map(string)
  default     = {}
}

variable "resources" {
  description = "Resource limits and requests for codecarbon containers"
  type = object({
    requests = object({
      cpu    = string
      memory = string
    })
    limits = object({
      cpu    = string
      memory = string
    })
  })
  default = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "200m"
      memory = "256Mi"
    }
  }
}
