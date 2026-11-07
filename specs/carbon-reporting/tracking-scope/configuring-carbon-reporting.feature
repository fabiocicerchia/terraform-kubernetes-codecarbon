@domain:carbon-reporting @area:tracking-scope @from:terraform-kubernetes-codecarbon/terraform-kubernetes-codecarbon
Feature: Configuring carbon reporting
  Lets the operator point every node agent at a CodeCarbon API and file its measurements under their organization, project and experiment, with the API key kept in a Secret.

  Background:
    Given the operator calls the CodeCarbon module with the deployment enabled

  @id:carbon-reporting.tracking-scope.001 @rule:carbon-reporting.tracking-scope.config-file-carries-scope @inferred @source:main.tf#locals
  Scenario Outline: The agent's configuration file carries the endpoint, scope and API key the operator gave
    Given the operator sets the API endpoint to "<endpoint>"
    And the operator sets organization "<org>", project "<project>" and experiment "<experiment>"
    When the operator applies the configuration
    Then the configuration Secret holds a .codecarbon.config file with a [codecarbon] section
    And that file lists api_endpoint = <endpoint>, organization_id = <org>, project_id = <project>, experiment_id = <experiment> and the given api_key
    And the agent reads that file at /root/.codecarbon.config

    Examples:
      | endpoint                   | org      | project      | experiment  |
      | https://api.codecarbon.io  | org_acme | proj_cluster | exp_prod    |
      | https://carbon.example.com | org_acme | proj_cluster | exp_staging |

  @id:carbon-reporting.tracking-scope.002 @rule:carbon-reporting.api-connection.defaults-to-public-service @inferred @source:main.tf#locals
  Scenario: Without any reporting settings the agent points at the public CodeCarbon API with an empty scope
    Given the operator sets no API endpoint, organization, project, experiment or API key
    When the operator applies the configuration
    Then the configuration file lists api_endpoint = https://api.codecarbon.io
    And organization_id, project_id, experiment_id and api_key are present with empty values
