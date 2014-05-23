Feature: Run Open vSwitch

  Background:
    Given a file named ".phut/config" with:
      """
      PID_DIR: .
      LOG_DIR: .
      SOCKET_DIR: .
      """

  @sudo
  Scenario: .pid and .log file is created
    When I successfully run Open vSwitch with dpid = "0xabc"
    Then a file named "open_vswitch.2748.pid" should exist
    And a file named "open_vswitch.2748.log" should exist

  @sudo
  Scenario: Run twice and fail
    Given I successfully run Open vSwitch with dpid = "0xabc"
    When I run Open vSwitch with dpid = "0xabc"
    Then it should raise "Open vSwitch (dpid = 2748) is already running!"
