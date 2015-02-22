@announce
Feature: DSL parser
  Scenario: name conflict (vsiwtch and vswitch)
    Given a file named "network.conf" with:
    """
    vswitch { dpid 0xabc }
    vswitch { dpid 0xabc }
    """
    When I do phut run "network.conf"
    Then the exit status should not be 0
    And the stderr should contain:
    """
    The name 0xabc conflicts with vswitch (name = 0xabc, dpid = 0xabc).
    """

  Scenario: name conflict (vhost and vhost)
    Given a file named "network.conf" with:
    """
    vhost { ip '192.168.0.1' }
    vhost { ip '192.168.0.1' }
    """
    When I do phut run "network.conf"
    Then the exit status should not be 0
    And the stderr should contain:
    """
    The name 192.168.0.1 conflicts with vhost (name = 192.168.0.1, ip = 192.168.0.1).
    """
