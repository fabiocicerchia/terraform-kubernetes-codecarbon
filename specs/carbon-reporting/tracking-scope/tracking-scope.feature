@domain:carbon-reporting @area:tracking-scope @from:terraform-kubernetes-codecarbon/variables
Feature: Attributing measurements to an organization, project and experiment
  Lets an operator file the cluster's emissions under the right CodeCarbon organization, project and experiment.

  @id:carbon-reporting.tracking-scope.003 @rule:carbon-reporting.tracking-scope.ids-optional-left-blank @inferred @source:variables.tf#organization_id @questionable
  Scenario Outline: Tracking identifiers are optional and left blank when not given
    Given the operator sets <field> to <value>
    When the operator applies the configuration
    Then the agent's configuration file contains "<field> = <written>"

    Examples:
      | field           | value     | written   |
      | organization_id | (not set) |           |
      | organization_id | org-0001  | org-0001  |
      | project_id      | (not set) |           |
      | project_id      | proj-0042 | proj-0042 |
      | experiment_id   | (not set) |           |
      | experiment_id   | exp-0007  | exp-0007  |
