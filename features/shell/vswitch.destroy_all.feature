Feature: Vswitch.destroy_all
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch.destroy_all
    When I type "Vswitch.destroy_all"
    And I type "Vswitch.all"
    And sleep 5
    Then the output should contain "[]"

  @sudo
  Scenario: Vswitch.destroy_all
    Given I type "Vswitch.create(dpid: 0xabc)"
    When I type "Vswitch.destroy_all"
    And I type "Vswitch.all"
    And sleep 5
    Then the output should contain "[]"
