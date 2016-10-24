Feature: Vswitch.all
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch.all #=> []
    When I type "Vswitch.all"
    Then the output should contain "[]"

  @sudo
  Scenario: Vswitch.all #=> [aVswitch]
    Given I type "Vswitch.create(name: 'firewall', dpid: 0xabc)"
    When I type "Vswitch.all"
    Then the output should contain:
     """
     [#<Vswitch name: "firewall", dpid: 0xabc, openflow_version: 1.0, tcp_port: 6653>]
     """

  @sudo
  Scenario: Vswitch.all #=> [aVswitch]
    Given I type "Vswitch.create(dpid: 0xabc)"
    When I type "Vswitch.all"
    Then the output should contain:
     """
     [#<Vswitch name: "0xabc", dpid: 0xabc, openflow_version: 1.0, tcp_port: 6653>]
     """
