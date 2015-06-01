@sudo
Feature: The vswitch DSL directive.
  Scenario: vswitch { dpid STRING }
    Given a file named "network.conf" with:
    """
    vswitch { dpid '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" (controller port = 6653) should be running

  Scenario: vswitch { dpid NUMBER }
    Given a file named "network.conf" with:
    """
    vswitch { dpid 0xabc }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" (controller port = 6653) should be running

  Scenario: vswitch { datapath_id STRING }
    Given a file named "network.conf" with:
    """
    vswitch { datapath_id '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" (controller port = 6653) should be running

  Scenario: vswitch { datapath_id NUMBER }
    Given a file named "network.conf" with:
    """
    vswitch { datapath_id 0xabc }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" (controller port = 6653) should be running

  Scenario: vswitch { dpid ...; port NUMBER }
    Given a file named "network.conf" with:
    """
    vswitch {
      datapath_id 0xabc
      port 1234
    }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" (controller port = 1234) should be running

  Scenario: vswitch(alias) { ... }
    Given a file named "network.conf" with:
    """
    vswitch('my_switch') { datapath_id '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "my_switch" (controller port = 6653) should be running
