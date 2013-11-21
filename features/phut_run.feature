@sudo
Feature: phut run command

  Background:
    Given a file named ".phuture/config" with:
      """
      PID_DIR: .
      LOG_DIR: .
      SOCKET_DIR: .
      """

  Scenario: phut run with `vswitch ...`
    And a file named "network.conf" with:
      """
      vswitch { dpid '0xabc' }
      """
    When I successfully run `phut run network.conf`
    Then a vswitch named "0xabc" launches

  Scenario: phut run with `vhost ...`
    And a file named "network.conf" with:
      """
      vhost { ip '192.168.0.1' }
      """
    When I successfully run `phut run network.conf`
    Then a vhost named "192.168.0.1" launches
