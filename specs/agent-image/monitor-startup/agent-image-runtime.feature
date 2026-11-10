@domain:agent-image @area:monitor-startup @from:terraform-kubernetes-codecarbon/dockerfile
Feature: Running the published CodeCarbon agent image
  Operators who pull the agent image, inside or outside the cluster, rely on it to start carbon monitoring on launch and to run with a known user identity.

  Background:
    Given the published CodeCarbon agent image built from this repository

  @id:agent-image.monitor-startup.001 @rule:agent-image.startup.monitors-by-default @inferred @source:Dockerfile#CMD
  Scenario: The agent image starts continuous carbon monitoring when launched without a command
    Given the operator supplies no command of their own
    When the operator starts a container from the agent image
    Then the container runs "codecarbon monitor"
    And it starts in the "/app" working directory

  @id:agent-image.monitor-startup.002 @rule:agent-image.security.runtime-user @inferred @source:Dockerfile#RUN @questionable
  Scenario: The agent image runs as root even though it creates an unprivileged user
    Given the image includes an unprivileged "codecarbon" user with UID 1000
    And the operator does not choose a user at launch
    When the operator starts a container from the agent image
    Then the monitoring process runs as root (UID 0)
    And the "codecarbon" user (UID 1000) is never used
