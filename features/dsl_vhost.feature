Feature: The vhost DSL directive.
  @sudo
  Scenario: phut run with "vhost { ip ... }"
    Given a file named "network.conf" with:
    """
    vhost { ip '192.168.0.1' }
    vhost { ip '192.168.0.2' }
    link '192.168.0.1', '192.168.0.2'
    """
    When I do phut run "network.conf"
    Then a vhost named "192.168.0.1" launches
    And a vhost named "192.168.0.2" launches

  @sudo
  Scenario: phut run with "vhost(alias) { ... }"
    Given a file named "network.conf" with:
    """
    vhost('host1') { ip '192.168.0.1' }
    vhost('host2') { ip '192.168.0.2' }
    link 'host1', 'host2'
    """
    When I do phut run "network.conf"
    Then a vhost named "host1" launches
    And a vhost named "host2" launches

  @sudo
  Scenario: phut run with "vhost(alias)"
    Given a file named "network.conf" with:
    """
    vhost('host1')
    vhost('host2')
    link 'host1', 'host2'
    """
    When I do phut run "network.conf"
    Then a vhost named "host1" launches
    And a vhost named "host2" launches

