Feature: The vswitch DSL directive.
  @sudo
  Scenario: phut run with "vswitch { dpid STRING }"
    Given a file named "network.conf" with:
    """
    vswitch { dpid '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  @sudo
  Scenario: phut run with "vswitch { dpid NUMBER }"
    Given a file named "network.conf" with:
    """
    vswitch { dpid 0xabc }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  @sudo
  Scenario: phut run with "vswitch { datapath_id STRING }"
    Given a file named "network.conf" with:
    """
    vswitch { datapath_id '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  @sudo
  Scenario: phut run with "vswitch { datapath_id NUMBER }"
    Given a file named "network.conf" with:
    """
    vswitch { datapath_id 0xabc }
    """
    When I do phut run "network.conf"
    Then a vswitch named "0xabc" launches

  @sudo
  Scenario: phut run with "vswitch(alias) { ... }"
    Given a file named "network.conf" with:
    """
    vswitch('my_switch') { datapath_id '0xabc' }
    """
    When I do phut run "network.conf"
    Then a vswitch named "my_switch" launches
