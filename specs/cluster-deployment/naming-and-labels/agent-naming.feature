@domain:cluster-deployment @area:naming-and-labels @from:terraform-kubernetes-codecarbon/variables
Feature: Naming the CodeCarbon agent
  Lets an operator name the agent so it is recognisable and its pods are selected by consistent labels.

  @id:cluster-deployment.naming-and-labels.001 @rule:cluster-deployment.naming-and-labels.default-agent-name @inferred @source:variables.tf#name
  Scenario Outline: The agent is named codecarbon unless another name is chosen
    Given the operator sets name to <name>
    When the operator applies the configuration
    Then the DaemonSet and its container are named <applied>
    And its pods carry app.kubernetes.io/name and app.kubernetes.io/instance labels of <applied>

    Examples:
      | name         | applied      |
      | (not set)    | codecarbon   |
      | carbon-agent | carbon-agent |
