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

This module deploys CodeCarbon as a DaemonSet with configuration stored in a Kubernetes Secret. The Secret contains a `.codecarbon.config` file that is mounted into the container.

### Configuration Method

The module uses a Secret-based configuration approach:
- Configuration is stored in a Kubernetes Secret as `.codecarbon.config`
- The Secret is mounted into the DaemonSet at `/root/.codecarbon.config`
- CodeCarbon reads this configuration file automatically
- This approach is more secure and cleaner than using individual environment variables

### Basic Example

```hcl
module "codecarbon" {
  source = "./terraform-kubernetes-codecarbon"

  enabled   = true
  name      = "codecarbon"
  namespace = "codecarbon"
}
```

### With CodeCarbon Dashboard Integration

```hcl
module "codecarbon" {
  source = "./terraform-kubernetes-codecarbon"

  enabled         = true
  name            = "codecarbon"
  namespace       = "codecarbon"
  api_endpoint    = "https://api.codecarbon.io"
  organization_id = "your-organization-id"
  project_id      = "your-project-id"
  experiment_id   = "your-experiment-id"
  api_key         = "your-api-key"
}
```

### Custom Configuration

```hcl
module "codecarbon" {
  source = "./terraform-kubernetes-codecarbon"

  enabled   = true
  name      = "my-codecarbon"
  namespace = "monitoring"
  image     = "fabiocicerchia/codecarbon:latest"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Enable or disable the codecarbon DaemonSet | `bool` | `true` | no |
| name | Name of the DaemonSet and container | `string` | `"codecarbon"` | no |
| namespace | Kubernetes namespace for codecarbon | `string` | `"codecarbon"` | no |
| image | Docker image for codecarbon | `string` | `"fabiocicerchia/codecarbon:latest"` | no |
| api_endpoint | CodeCarbon API endpoint URL | `string` | `"https://api.codecarbon.io"` | no |
| organization_id | CodeCarbon organization ID | `string` | `""` | no |
| project_id | CodeCarbon project ID | `string` | `""` | no |
| experiment_id | CodeCarbon experiment ID | `string` | `""` | no |
| api_key | CodeCarbon API key (sensitive) | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| namespace | The namespace where codecarbon is deployed |
| daemonset_name | The name of the codecarbon DaemonSet |
| enabled | Whether codecarbon is enabled |

## CodeCarbon Dashboard

To use the CodeCarbon Dashboard for tracking emissions data, you need to configure the following settings which are stored in a Kubernetes Secret.

### Configuration Secret

The module creates a Kubernetes Secret containing a `.codecarbon.config` file with the following structure:

```ini
[codecarbon]
api_endpoint = https://api.codecarbon.io
organization_id = <your-organization-id>
project_id = <your-project-id>
experiment_id = <your-experiment-id>
api_key = <your-api-key>
```

This configuration file is automatically mounted into the DaemonSet at `/root/.codecarbon.config` and is used by CodeCarbon to authenticate and report emissions data to the dashboard.

### Setting Up CodeCarbon Dashboard

### 1. Install CodeCarbon CLI

```bash
pip install codecarbon
```

### 2. Authenticate with CodeCarbon

```bash
codecarbon login
```

This will open your browser to complete authentication. Once successful, you'll see:
```
Successfully authenticated Getting a token...
```

### 3. Configure CodeCarbon

Run the interactive configuration wizard:

```bash
codecarbon config
```

The wizard will guide you through:
- Creating/selecting an organization
- Creating/selecting a project
- Creating/selecting an experiment
- Configuring location settings (country, region)

Example configuration session:
```
Welcome to CodeCarbon configuration wizard
Creating new config file
Where do you want to put your config file ? [~/.codecarbon.config]:
Config file created at /home/user/.codecarbon.config
Current API endpoint is https://api.codecarbon.io. Press enter to continue or input other url [https://api.codecarbon.io]:
? Pick existing organization from list or Create new organization ? Your Organization
? Pick existing project from list or Create new project ? Your Project
? Pick existing experiment from list or Create new experiment ? Create New Experiment
Creating new experiment
Experiment name : [Code Carbon user test]: My K8s Cluster
Experiment description : [Code Carbon user test ]: Carbon emissions from production cluster
Is this experiment running on the cloud ? [y/n]: n
Country name : [Auto]: US
Country ISO code : [Auto]: US
Region : [Auto]: US-CA
[...]
```

### 4. Get Your Credentials

After configuration, you can find your credentials:

**From the CLI configuration file** (`~/.codecarbon.config`):
```bash
cat ~/.codecarbon.config
```

The file contains:
- `organization_id` - Your organization identifier
- `project_id` - Your project identifier
- `experiment_id` - Your experiment identifier
- `api_key` - Your authentication key

**From the Dashboard**:
1. Go to [https://dashboard.codecarbon.io](https://dashboard.codecarbon.io)
2. Navigate to your experiment
3. Copy the `organization_id`, `project_id`, and `experiment_id`
4. Generate an API key if needed

### 5. Configure the Module

Use the credentials in your Terraform configuration:

```hcl
module "codecarbon" {
  source = "./terraform-kubernetes-codecarbon"

  enabled         = true
  api_endpoint    = "https://api.codecarbon.io"
  organization_id = "your-organization-id"
  project_id      = "your-project-id"
  experiment_id   = "your-experiment-id"
  api_key         = "your-api-key"
}
```

Your emissions data will now be sent to the CodeCarbon Dashboard for visualization and analysis.

Your emissions data will now be sent to the CodeCarbon Dashboard for visualization and analysis.

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
