@domain:cluster-deployment @area:namespace-placement @from:terraform-kubernetes-codecarbon/variables
Feature: Choosing the namespace for the monitoring stack
  Lets an operator place the CodeCarbon stack in a namespace of their choice, with a sensible default.

  @id:cluster-deployment.namespace-placement.001 @rule:cluster-deployment.namespace-placement.default-codecarbon-namespace @inferred @source:variables.tf#namespace
  Scenario Outline: The stack lives in the codecarbon namespace unless another is chosen
    Given the operator sets namespace to <namespace>
    When the operator applies the configuration
    Then a namespace named <created> exists
    And the CodeCarbon agent and its configuration Secret are placed in <created>
    And the namespace output is <created>

    Examples:
      | namespace     | created       |
      | (not set)     | codecarbon    |
      | observability | observability |
