@sudo
Feature: The vhost DSL directive.

  Background:
    Given a file named ".phut/config" with:
      """
      PID_DIR: .
      LOG_DIR: .
      SOCKET_DIR: .
      """

  Scenario: phut run with `vhost { ip ... }`
    Given a file named "network.conf" with:
      """
      vhost { ip '192.168.0.1' }
      """
    When I do phut run "network.conf"
    Then a vhost named "192.168.0.1" launches

  Scenario: phut run with `vhost(alias) { ... }`
    Given a file named "network.conf" with:
      """
      vhost('host1') { ip '192.168.0.1' }
      """
    When I do phut run "network.conf"
    Then a vhost named "host1" launches

