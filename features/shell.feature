Feature: Shell
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch inspection
    Given I type "Vswitch.create(name: 'firewall', dpid: 0xabc)"
    Then the output should contain:
     """
     #<Vswitch name: "firewall", dpid: 0xabc, openflow_version: "1.0", bridge: "vsw_firewall">
     """

  @sudo
  Scenario: Vswitch#stop 
    Given I type "vswitch = Vswitch.create(dpid: 0xabc)"
    When I type "vswitch.stop"
    Then a vswitch named "0xabc" should not be running
