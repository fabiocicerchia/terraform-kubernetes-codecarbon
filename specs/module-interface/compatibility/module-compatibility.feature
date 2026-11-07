@domain:module-interface @area:compatibility @from:terraform-kubernetes-codecarbon/versions
Feature: Declaring supported tool versions
  Tells operators which Terraform/OpenTofu releases and which kubectl provider the module works with, so an unsupported setup is refused before anything reaches the cluster.

  Background:
    Given the operator's root module calls the CodeCarbon module

  @id:module-interface.compatibility.001 @rule:module.compatibility.minimum-cli-version @inferred @source:versions.tf#terraform
  Scenario Outline: Only Terraform 1.0 or later, or any OpenTofu release, can use the module
    Given the operator runs <cli> version <version>
    When the operator initialises the root module
    Then initialisation <outcome>

    Examples:
      | cli       | version | outcome                                                                                     |
      | Terraform | 0.15.5  | is refused with an unsupported Terraform Core version error naming the ">= 1.0" requirement |
      | Terraform | 1.0.0   | proceeds                                                                                    |
      | Terraform | 1.9.8   | proceeds                                                                                    |
      | OpenTofu  | 1.6.0   | proceeds                                                                                    |

  @id:module-interface.compatibility.002 @rule:module.compatibility.kubectl-provider-requirement @inferred @source:versions.tf#terraform
  Scenario Outline: The module needs the gavinbunney/kubectl provider at version 1.14 or later
    Given the operator's configuration allows kubectl provider versions <constraint>
    When the operator initialises the root module
    Then initialisation <outcome>

    Examples:
      | constraint    | outcome                                                          |
      | unconstrained | installs the latest gavinbunney/kubectl release at 1.14 or above |
      | "= 1.13.0"    | is refused because no provider version matches both constraints  |
      | "~> 1.14"     | installs a gavinbunney/kubectl 1.x release at 1.14 or above      |
