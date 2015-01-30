@sudo
Feature: The link DSL directive.
  Background:
    Given a file named ".phut/config" with:
    """
    PID_DIR: .
    LOG_DIR: .
    SOCKET_DIR: .
    """
    And I successfully run `sudo -v`

  Scenario: phut run with "link ..."
    Given a file named "network.conf" with:
    """
    vswitch { dpid '0xabc' }
    vhost { ip '192.168.0.1' }
    link '0xabc', '192.168.0.1'
    """
    When I do phut run "network.conf"
    Then a link is created between "0xabc" and "192.168.0.1"

  Scenario: phut run with "link alias1, alias2"
    Given a file named "network.conf" with:
    """
    vswitch('my_switch') { dpid '0xabc' }
    vhost('host1') { ip '192.168.0.1' }
    link 'my_switch', 'host1'
    """
    When I do phut run "network.conf"
    Then a link is created between "my_switch" and "host1"
