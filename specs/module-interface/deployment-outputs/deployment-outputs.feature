@domain:module-interface @area:deployment-outputs @from:terraform-kubernetes-codecarbon/outputs
Feature: Reporting what was deployed
  Gives operators and calling modules the namespace, agent name, enabled state and manifest of the CodeCarbon deployment so they can wire it into other configuration.

  Background:
    Given the operator calls the CodeCarbon module from a root configuration

  @id:module-interface.deployment-outputs.001 @rule:module.outputs.report-deployed-agent @inferred @source:outputs.tf#daemonset_name
  Scenario Outline: An enabled deployment reports its namespace, agent name and enabled state
    Given the deployment is enabled
    And the operator sets the namespace to <namespace> and the name to <name>
    When the operator applies the configuration
    Then the namespace output is <namespace>
    And the daemonset_name output is <name>
    And the enabled output is true

    Examples:
      | namespace     | name         |
      | codecarbon    | codecarbon   |
      | observability | carbon-agent |

  @id:module-interface.deployment-outputs.002 @rule:module.outputs.disabled-reports-no-agent @inferred @source:outputs.tf#daemonset_name
  Scenario: A disabled deployment reports no agent and no manifest
    Given the deployment is disabled
    When the operator applies the configuration
    Then the enabled output is false
    And the daemonset_name output is empty
    And the manifest_yaml output is empty

  @id:module-interface.deployment-outputs.003 @rule:module.outputs.namespace-reported-when-disabled @inferred @source:outputs.tf#namespace @questionable
  Scenario: The namespace is reported even when nothing is deployed
    Given the deployment is disabled
    And the operator sets the namespace to observability
    When the operator applies the configuration
    Then the namespace output is observability
    And no namespace named observability is created in the cluster

  @id:module-interface.deployment-outputs.004 @rule:module.outputs.manifest-reflects-bundled-template @inferred @source:outputs.tf#manifest_yaml @questionable
  Scenario: The manifest output is the bundled template, without the operator's settings
    Given the deployment is enabled
    And the operator sets the name to carbon-agent, the namespace to observability and an organization ID of org-1234
    When the operator applies the configuration
    Then the manifest_yaml output names the namespace and DaemonSet codecarbon
    And the manifest_yaml output uses the image fabiocicerchia/codecarbon:latest
    And the manifest_yaml output carries an empty organization ID and API key
