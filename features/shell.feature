@shell
Feature: Shell

  Background:
    Given a file named ".phut/config" with:
    """
    PID_DIR: .
    LOG_DIR: .
    SOCKET_DIR: .
    """
    And I successfully run `sudo -v`

  Scenario: Run a vswitch
    Given I run `phut` interactively
    When I type "vswitch 0xabc"
    And I type "quit"
    Then a file named "open_vswitch.0xabc.pid" should exist
    And a file named "open_vswitch.0xabc.log" should exist

  Scenario: Run twice and fail
    Given I run `phut` interactively
    And I type "vswitch 0xabc"
    When I type "vswitch 0xabc"
    And I type "quit"
    Then the output should contain "already running!"

  Scenario: Kill and .pid is deleted
    Given I run `phut` interactively
    And I type "vswitch 0xabc"
    When I type "kill 0xabc"
    And I type "quit"
    Then a file named "open_vswitch.0xabc.pid" should not exist

  Scenario: Kill without run and fail
    Given I run `phut` interactively
    When I type "kill 0xabc"
    And I type "quit"
    Then the output should contain "not running!"
