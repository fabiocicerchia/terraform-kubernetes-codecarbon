@domain:agent-image @area:image-selection @from:terraform-kubernetes-codecarbon/variables
Feature: Choosing the agent container image
  Lets an operator run the published CodeCarbon image or substitute their own.

  @id:agent-image.image-selection.001 @rule:agent-image.image-selection.default-published-image @inferred @source:variables.tf#image @questionable
  Scenario Outline: The agent runs the published latest image unless another is chosen
    Given the operator sets image to <image>
    When the operator applies the configuration
    Then the agent container runs <runs>

    Examples:
      | image                                 | runs                                  |
      | (not set)                             | fabiocicerchia/codecarbon:latest      |
      | registry.example.com/codecarbon:2.4.1 | registry.example.com/codecarbon:2.4.1 |
