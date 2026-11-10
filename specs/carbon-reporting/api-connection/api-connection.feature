@domain:carbon-reporting @area:api-connection @from:terraform-kubernetes-codecarbon/variables
Feature: Connecting the agent to a CodeCarbon API
  Lets an operator send measurements to the public CodeCarbon service or a self-hosted endpoint.

  @id:carbon-reporting.api-connection.001 @rule:carbon-reporting.api-connection.default-public-endpoint @inferred @source:variables.tf#api_endpoint
  Scenario Outline: Measurements go to the public CodeCarbon API unless another endpoint is chosen
    Given the operator sets api_endpoint to <api_endpoint>
    When the operator applies the configuration
    Then the agent's configuration file contains "api_endpoint = <reported>"

    Examples:
      | api_endpoint                   | reported                       |
      | (not set)                      | https://api.codecarbon.io      |
      | https://codecarbon.example.com | https://codecarbon.example.com |
