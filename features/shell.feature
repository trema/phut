Feature: Shell
  Background:
    Given I run `phut -v` interactively
    And I wait for stdout to contain "phut>"

  @shell
  Scenario: vswitch NUMBER
    When I type "vswitch 0xabc"
    And I type "quit"
    And I run `sleep 1`
    Then a vswitch named "0xabc" should be running

  @shell
  Scenario: vswitch STRING
    When I type "vswitch '0xabc'"
    And I type "quit"
    And I run `sleep 1`
    Then a vswitch named "0xabc" should be running

  @shell
  Scenario: dump_flows
    Given I type "vswitch '0xabc'"
    When I type "dump_flows 0xabc"
    And I type "quit"
    And I run `sleep 1`
    Then the output should contain "NXST_FLOW reply"

  @shell
  Scenario: vswitch twice and fail
    And I type "vswitch 0xabc"
    When I type "vswitch 0xabc"
    And I type "quit"
    Then the output should contain "Open vSwitch (dpid = 0xabc) is already running!"

  @shell
  Scenario: Kill and .pid is deleted
    And I type "vswitch 0xabc"
    When I type "kill 0xabc"
    And I type "quit"
    And I run `sleep 1`
    Then a vswitch named "0xabc" should not be running

  @shell
  Scenario: Kill without run and fail
    When I type "kill 0xabc"
    And I type "quit"
    Then the output should contain "Open vSwitch (dpid = 0xabc) is not running!"
