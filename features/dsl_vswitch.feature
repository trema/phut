@sudo
Feature: The vswitch DSL directive.

  Background:
    Given a file named ".phut/config" with:
    """
    PID_DIR: .
    LOG_DIR: .
    SOCKET_DIR: .
    """
    And I successfully run `sudo -v`

  Scenario: phut run with "vswitch { dpid ... }"
    Given a file named "network.conf" with:
    """
    vswitch { dpid '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  Scenario: phut run with "vswitch { datapath_id ... }"
    Given a file named "network.conf" with:
    """
    vswitch { datapath_id '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  Scenario: phut run with "vswitch(alias) { ... }"
    Given a file named "network.conf" with:
    """
    vswitch('my_switch') { datapath_id '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "my_switch" launches
