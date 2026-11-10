@domain:cluster-deployment @area:enable-toggle @from:terraform-kubernetes-codecarbon/variables
Feature: Switching the CodeCarbon deployment on or off
  Lets an operator keep the module call in place while deciding whether anything is deployed to the cluster.

  Background:
    Given the operator calls the codecarbon module from their Terraform configuration

  @id:cluster-deployment.enable-toggle.001 @rule:cluster-deployment.enable-toggle.on-unless-disabled @inferred @source:variables.tf#enabled
  Scenario Outline: The deployment is on unless the operator switches it off
    Given the operator sets enabled to <enabled>
    When the operator applies the configuration
    Then the namespace, configuration Secret and DaemonSet are <outcome>
    And the daemonset_name output is <daemonset_name>

    Examples:
      | enabled   | outcome                | daemonset_name |
      | (not set) | applied to the cluster | codecarbon     |
      | true      | applied to the cluster | codecarbon     |
      | false     | not applied            | null           |
