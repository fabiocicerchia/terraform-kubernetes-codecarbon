@domain:cluster-deployment @area:node-agent-rollout @from:terraform-kubernetes-codecarbon/terraform-kubernetes-codecarbon
Feature: Deploying the CodeCarbon agent to a cluster
  Gives a platform operator a single module call that puts a CodeCarbon monitoring agent on every node, in the namespace, under the name and with the image they choose.

  Background:
    Given the operator calls the CodeCarbon module from their root configuration against a reachable Kubernetes cluster

  @id:cluster-deployment.node-agent-rollout.002 @rule:cluster-deployment.naming-and-labels.agent-named-and-selected-by-name @inferred @source:main.tf#locals @questionable
  Scenario: The agent, its container and its pod labels carry the chosen name
    Given the operator sets the name to "my-codecarbon"
    When the operator applies the configuration
    Then the agent DaemonSet is named "my-codecarbon"
    And its container is named "my-codecarbon"
    And its pods are labelled app.kubernetes.io/name=my-codecarbon and app.kubernetes.io/instance=my-codecarbon and selected by those labels
    And the DaemonSet's own labels stay app.kubernetes.io/name=codecarbon and app.kubernetes.io/instance=codecarbon
    And the configuration Secret stays named "codecarbon-config"
