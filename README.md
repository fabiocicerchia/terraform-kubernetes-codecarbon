# Terraform Module for CodeCarbon

Terraform module to deploy [CodeCarbon](https://github.com/mlco2/codecarbon) as a DaemonSet on Kubernetes to monitor carbon emissions across all nodes.

## Why This Matters

Every computation has a carbon cost. As organisations commit to net-zero targets and ESG reporting, measuring the actual carbon emissions of compute workloads becomes essential—not just for compliance, but for meaningful reduction.

CodeCarbon makes carbon emissions visible by:

* 🌍 **Quantifying CO₂ emissions** from your infrastructure in real metrics (tons CO₂e)
* 📊 **Tracking emissions over time** to measure progress toward reduction goals
* 🔬 **Identifying carbon-intensive workloads** for optimisation
* 📈 **Supporting ESG reporting** with concrete, measurable data
* 🎯 **Enabling carbon-aware decisions** in architecture and workload placement

By monitoring carbon emissions alongside performance metrics, teams can optimise for environmental impact—turning sustainability from aspiration into measurable operational practice.

## Overview

CodeCarbon tracks and estimates the carbon emissions of compute resources. This module deploys CodeCarbon as a DaemonSet, running `codecarbon monitor` on every node in your Kubernetes cluster to provide comprehensive carbon tracking.

## Features

- **DaemonSet Deployment**: Runs on all cluster nodes for complete coverage
- **Host Access**: Mounts `/proc` and `/sys` for accurate resource monitoring
- **API Integration**: Optional integration with CodeCarbon Dashboard
- **Configurable Resources**: Customizable CPU and memory limits
- **Tolerations**: Runs on all nodes including tainted ones

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 or OpenTofu >= 1.6 |
| kubectl | >= 1.14 |

## Building the Docker Image

The module uses a custom Docker image. To build and push it:

```bash
# Build the image
docker build -t fabiocicerchia/codecarbon:latest .

# Push to registry
docker push fabiocicerchia/codecarbon:latest
```

Or use a custom image name and tag:

```bash
IMAGE_NAME="your-registry/codecarbon" TAG="v1.0.0" bash -c '
  docker build -t "${IMAGE_NAME}:${TAG}" .
  docker push "${IMAGE_NAME}:${TAG}"
'
```

Then configure the module to use your custom image:

```hcl
module "codecarbon" {
  source = "./terraform-kubernetes-codecarbon"
  
  image = "your-registry/codecarbon:v1.0.0"
}
```

## Standalone Usage (Without Terraform)

You can deploy CodeCarbon directly with kubectl using the provided YAML manifest:

```bash
# Deploy with default settings
kubectl apply -f codecarbon-daemonset.yaml

# Or customise the YAML file first, then apply
kubectl apply -f codecarbon-daemonset.yaml
```

To remove the deployment:

```bash
kubectl delete -f codecarbon-daemonset.yaml
```

## Usage with Terraform

This module reads Kubernetes manifests from `codecarbon-daemonset.yaml` and applies variable overrides for `name`, `namespace`, `image`, `api_url`, `experiment_id`, and `api_key`.

### Basic Example

```hcl
module "codecarbon" {
  source = "./terraform-helm-codecarbon"

  enabled   = true
  name      = "codecarbon"
  namespace = "codecarbon"
}
```

### With CodeCarbon Dashboard Integration

```hcl
module "codecarbon" {
  source = "./terraform-helm-codecarbon"

  enabled       = true
  name          = "codecarbon"
  namespace     = "codecarbon"
  api_url       = "https://api.codecarbon.io"
  experiment_id = "your-experiment-id"
  api_key       = "your-api-key"
}
```

### Custom Configuration

```hcl
module "codecarbon" {
  source = "./terraform-helm-codecarbon"

  enabled   = true
  name      = "my-codecarbon"
  namespace = "monitoring"
  image     = "codecarbon/codecarbon:v2.4.1"
  
  resources = {
    requests = {
      cpu    = "50m"
      memory = "64Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Enable or disable the codecarbon DaemonSet | `bool` | `true` | no |
| name | Name of the DaemonSet and container | `string` | `"codecarbon"` | no |
| namespace | Kubernetes namespace for codecarbon | `string` | `"codecarbon"` | no |
| image | Docker image for codecarbon | `string` | `"codecarbon/codecarbon:v2.4.1"` | no |
| api_url | CodeCarbon API URL for reporting emissions | `string` | `""` | no |
| experiment_id | CodeCarbon experiment ID | `string` | `""` | no |
| api_key | CodeCarbon API key | `string` | `""` | no |
| extra_env | Additional environment variables | `map(string)` | `{}` | no |
| resources | Resource limits and requests | `object` | See below | no |

Default resources:
```hcl
{
  requests = {
    cpu    = "100m"
    memory = "128Mi"
  }
  limits = {
    cpu    = "200m"
    memory = "256Mi"
  }
}
```

## Outputs

| Name | Description |
|------|-------------|
| namespace | The namespace where codecarbon is deployed |
| daemonset_name | The name of the codecarbon DaemonSet |
| enabled | Whether codecarbon is enabled |

## CodeCarbon Dashboard

To use the CodeCarbon Dashboard:

1. Create an account at [https://dashboard.codecarbon.io](https://dashboard.codecarbon.io)
2. Create an experiment to get your `experiment_id`
3. Generate an API key
4. Configure the module with these credentials

## Security Considerations

This DaemonSet requires:
- **Privileged mode**: To access host metrics
- **Host network and PID**: For accurate resource monitoring
- **Host path mounts**: `/proc` and `/sys` for system information

These permissions are necessary for accurate carbon measurement but should be reviewed according to your security policies.

## Notes

- CodeCarbon calculates emissions based on CPU/GPU usage and regional carbon intensity
- Data can be stored locally or sent to the CodeCarbon Dashboard
- The DaemonSet includes tolerations to run on all nodes, including master nodes
- Consider the resource overhead when running on many nodes

## License

MIT

## References

- [CodeCarbon GitHub](https://github.com/mlco2/codecarbon)
- [CodeCarbon Documentation](https://mlco2.github.io/codecarbon)
- [CodeCarbon Dashboard](https://dashboard.codecarbon.io)
