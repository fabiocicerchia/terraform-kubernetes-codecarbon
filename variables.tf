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
  default     = "fabiocicerchia/codecarbon:latest"
}

variable "api_endpoint" {
  description = "CodeCarbon API endpoint URL"
  type        = string
  default     = "https://api.codecarbon.io"
}

variable "organization_id" {
  description = "CodeCarbon organization ID"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "CodeCarbon project ID"
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
