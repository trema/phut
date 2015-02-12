Feature: Shell
  Background:
    Given I run `phut -v` interactively
    And I type "pid_dir '.'"
    And I type "log_dir '.'"
    And I type "socket_dir '.'"

  @shell
  Scenario: vswitch NUMBER
    When I type "vswitch 0xabc"
    And I type "quit"
    Then a file named "open_vswitch.0xabc.pid" should exist
    And a file named "open_vswitch.0xabc.log" should exist

  @shell
  Scenario: vswitch STRING
    When I type "vswitch '0xabc'"
    And I type "quit"
    Then a file named "open_vswitch.0xabc.pid" should exist
    And a file named "open_vswitch.0xabc.log" should exist

  @shell
  Scenario: vswitch twice and fail
    And I type "vswitch 0xabc"
    When I type "vswitch 0xabc"
    And I type "quit"
    Then the output should contain "already running!"

  @shell
  Scenario: Kill and .pid is deleted
    And I type "vswitch 0xabc"
    When I type "kill 0xabc"
    And I type "quit"
    Then a file named "open_vswitch.0xabc.pid" should not exist

  @shell
  Scenario: Kill without run and fail
    When I type "kill 0xabc"
    And I type "quit"
    Then the output should contain "Open vSwitch (dpid = 0xabc) is not running!"
