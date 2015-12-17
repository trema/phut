Feature: Shell
  Background:
    Given I wait 5 seconds for a command to start up
    And I run `phut -v` interactively

  @shell
  Scenario: vswitch NUMBER
    When I type "vswitch 0xabc"
    And I type "quit"
    And sleep 1
    Then a vswitch named "0xabc" should be running

  @shell
  Scenario: vswitch STRING
    When I type "vswitch '0xabc'"
    And I type "quit"
    And sleep 1
    Then a vswitch named "0xabc" should be running

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
    And sleep 1
    Then a vswitch named "0xabc" should not be running

  @shell
  Scenario: Kill without run and fail
    When I type "kill 0xabc"
    And I type "quit"
    Then the output should contain "Open vSwitch (dpid = 0xabc) is not running!"
