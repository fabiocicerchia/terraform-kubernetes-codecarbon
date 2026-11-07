# Specifications of terraform-kubernetes-codecarbon

What this code does, one atomic Gherkin scenario per behaviour, read from the code by code-atlas.
Tags: `@verified` a test asserts it · `@inferred` read from the code only · `@gap` an entry point no test covers · `@human` written or amended by a person, never rewritten.

## Agent Image
The container image that runs CodeCarbon monitoring on each node.

- **Image selection**: [Choosing the agent container image](agent-image/image-selection/agent-image-selection.feature) (1)
- **Monitor startup**: [Running the published CodeCarbon agent image](agent-image/monitor-startup/agent-image-runtime.feature) (2)

## Carbon Reporting
Connecting the agent to the CodeCarbon service so emissions are tracked against the right account.

- **API connection**: [Connecting the agent to a CodeCarbon API](carbon-reporting/api-connection/api-connection.feature) (1)
- **Credentials**: [Protecting the CodeCarbon API key](carbon-reporting/credentials/api-credentials.feature) (1)
- **Tracking scope**: [Configuring carbon reporting](carbon-reporting/tracking-scope/configuring-carbon-reporting.feature) (2), [Attributing measurements to an organization, project and experiment](carbon-reporting/tracking-scope/tracking-scope.feature) (1)

## Cluster Deployment
Rolling the CodeCarbon monitoring agent out to every node of a Kubernetes cluster.

- **Enable toggle**: [Switching the CodeCarbon deployment on or off](cluster-deployment/enable-toggle/enable-toggle.feature) (1)
- **Namespace placement**: [Choosing the namespace for the monitoring stack](cluster-deployment/namespace-placement/namespace-placement.feature) (1)
- **Naming and labels**: [Naming the CodeCarbon agent](cluster-deployment/naming-and-labels/agent-naming.feature) (1)
- **Node agent rollout**: [Deploying the CodeCarbon agent to a cluster](cluster-deployment/node-agent-rollout/deploying-codecarbon-agent.feature) (3)

## Developer Tooling
Local commands and quality gates for maintaining the module.

- **Task commands**: [Running the repository's standard make verbs](developer-tooling/task-commands/make-verbs.feature) (4)

## Module Interface
How users consume the Terraform module and what it tells them back.

- **Compatibility**: [Declaring supported tool versions](module-interface/compatibility/module-compatibility.feature) (2)
- **Deployment outputs**: [Reporting what was deployed](module-interface/deployment-outputs/deployment-outputs.feature) (4)
- **Usage example**: [Deploying CodeCarbon from the usage example](module-interface/usage-example/usage-example.feature) (3)
