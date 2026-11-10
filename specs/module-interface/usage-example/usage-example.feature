@domain:module-interface @area:usage-example @from:examples/examples
Feature: Deploying CodeCarbon from the usage example
  Gives an operator a ready-to-copy root module that deploys the CodeCarbon agent and shows where its deployment lands, so they can start measuring cluster emissions without studying the module.

  Background:
    Given the operator has copied the usage example as their root configuration
    And the operator's kubectl provider can reach a Kubernetes cluster

  @id:module-interface.usage-example.001 @rule:module.usage-example.deploys-agent-to-public-api @inferred @source:examples/main.tf#codecarbon
  Scenario: The example deploys an enabled agent named codecarbon in the codecarbon namespace reporting to the public CodeCarbon API
    Given the operator has not changed the example's name, namespace or API endpoint
    When the operator applies the example
    Then a DaemonSet named "codecarbon" runs in the namespace "codecarbon"
    And the agent's configuration points at "https://api.codecarbon.io"
    And the agent's measurements are attributed to the experiment ID set in the example

  @id:module-interface.usage-example.002 @rule:module.usage-example.placeholder-credentials-applied-verbatim @inferred @source:examples/main.tf#codecarbon @questionable
  Scenario: The example's placeholder experiment ID and API key are deployed unchanged unless the operator replaces them
    Given the operator has not replaced the example's experiment ID or API key
    When the operator applies the example
    Then the agent's stored configuration holds experiment_id "your-experiment-id" and api_key "your-api-key"
    And the agent's stored configuration holds empty organization_id and project_id
    And Terraform raises no warning or error about the placeholder values

  @id:module-interface.usage-example.003 @rule:module.usage-example.surfaces-deployment-outputs @inferred @source:examples/outputs.tf#namespace
  Scenario: The example reports the namespace, agent name and enabled state after apply but not the rendered manifest
    Given the operator has not changed the example's outputs
    When the operator applies the example
    Then the output "namespace" is "codecarbon"
    And the output "daemonset_name" is "codecarbon"
    And the output "enabled" is true
    And no "manifest_yaml" output is shown
