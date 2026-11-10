@domain:carbon-reporting @area:credentials @from:terraform-kubernetes-codecarbon/variables
Feature: Protecting the CodeCarbon API key
  Protects the operator's CodeCarbon API key while handing it to the agent.

  @id:carbon-reporting.credentials.001 @rule:carbon-reporting.credentials.api-key-sensitive @inferred @source:variables.tf#api_key @questionable
  Scenario: The API key is declared sensitive and delivered to the agent in a Secret
    Given the operator sets api_key to "ck_example_not_a_real_key"
    When the operator applies the configuration
    Then Terraform treats api_key as a sensitive input
    And the codecarbon-config Secret's configuration file contains "api_key = ck_example_not_a_real_key"
