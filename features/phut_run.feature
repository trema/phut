@sudo
Feature: phut run command

  Background:
    Given a file named ".phuture/config" with:
      """
      PID_DIR: .
      LOG_DIR: .
      SOCKET_DIR: .
      """

  Scenario: phut run with `vswitch { dpid ... }`
    Given a file named "network.conf" with:
      """
      vswitch { dpid '0xabc' }
      """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  Scenario: phut run with `vswitch { datapath_id ... }`
    Given a file named "network.conf" with:
      """
      vswitch { datapath_id '0xabc' }
      """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  Scenario: phut run with `vhost ...`
    Given a file named "network.conf" with:
      """
      vhost { ip '192.168.0.1' }
      """
    When I do phut run "network.conf"
    Then a vhost named "192.168.0.1" launches

  Scenario: phut run with `link ...`
    Given a file named "network.conf" with:
      """
      vswitch { dpid '0xabc' }
      vhost { ip '192.168.0.1' }
      link '0xabc', '192.168.0.1'
      """
    When I do phut run "network.conf"
    Then a link is created between "0xabc" and "192.168.0.1"
