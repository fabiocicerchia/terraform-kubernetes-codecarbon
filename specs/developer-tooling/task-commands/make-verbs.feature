@domain:developer-tooling @area:task-commands @from:terraform-kubernetes-codecarbon/makefile
Feature: Running the repository's standard make verbs
  Gives contributors the same eight make verbs as every repository in the estate, so they can set up, check and validate the module without reading the Makefile, and never get a silent success.

  Background:
    Given the contributor has a checkout of the terraform-kubernetes-codecarbon module

  @id:developer-tooling.task-commands.001 @rule:tooling.make.bare-make-lists-verbs @inferred @source:Makefile#help
  Scenario: Running make with no verb lists the available verbs
    When the contributor runs make with no verb
    Then the help listing is printed instead of any other verb running
    And each of help, setup, install, lint, format, test, analyze, build and run is shown with its one-line description

  @id:developer-tooling.task-commands.002 @rule:tooling.make.not-applicable-verbs-explain-themselves @inferred @source:Makefile#build
  Scenario Outline: Verbs that do not apply to a Terraform module say why and succeed
    When the contributor runs make <verb>
    Then the message "<message>" is printed
    And the message "See README > Not applicable." is printed
    And the command exits with status 0

    Examples:
      | verb  | message                                                                  |
      | build | Nothing to build: this is a Terraform module, consumed from source.      |
      | run   | Nothing to run: a module is called by a root module, never run directly. |

  @id:developer-tooling.task-commands.003 @rule:tooling.make.analyze-refuses-without-tflint @inferred @source:Makefile#analyze
  Scenario: Analysis refuses to run when tflint is not installed
    Given tflint is not installed on the contributor's machine
    When the contributor runs make analyze
    Then the error "analyze needs tflint: https://github.com/terraform-linters/tflint" is printed
    And make reports that the analyze step failed with error 69
    And the command exits with a non-zero status
    And no lint findings are reported

  @id:developer-tooling.task-commands.004 @rule:tooling.make.test-validates-module-and-example @inferred @source:Makefile#test
  Scenario: Testing validates both the module and its usage example
    When the contributor runs make test
    Then the module's Terraform configuration is validated
    And the example root module under examples is validated
    And the command fails if either configuration is invalid
