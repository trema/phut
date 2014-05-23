Feature: Shell

  Background:
    Given a file named ".phut/config" with:
      """
      PID_DIR: .
      LOG_DIR: .
      SOCKET_DIR: .
      """

  Scenario: Prompt
    When I run `phut` interactively
    And I type "quit"
    Then the output should contain "phut>"

  @sudo
  Scenario: Run a vswitch
    Given I run `phut` interactively
    When I type "vswitch 0xabc"
    And I type "quit"
    Then a file named "open_vswitch.2748.pid" should exist
    And a file named "open_vswitch.2748.log" should exist

  @sudo
  Scenario: Run twice and fail
    Given I run `phut` interactively
    And I type "vswitch 0xabc"
    When I type "vswitch 0xabc"
    And I type "quit"
    Then the output should contain "already running!"

  @sudo
  Scenario: Kill and .pid is deleted
    Given I run `phut` interactively
    And I type "vswitch 0xabc"
    When I type "kill 0xabc"
    And I type "quit"
    Then a file named "open_vswitch.2748.pid" should not exist

  @sudo
  Scenario: Kill without running and fail
    Given I run `phut` interactively
    When I type "kill 0xabc"
    And I type "quit"
    Then the output should contain "not running!"
