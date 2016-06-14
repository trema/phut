Feature: Vswitch.create
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch.create(dpid: ...)
    When I type "Vswitch.create(dpid: 0xabc)"
    And sleep 5
    Then a vswitch named "0xabc" should be running

  @sudo
  Scenario: Vswitch.create(name: ..., dpid: ...)
    When I type "Vswitch.create(name: 'firewall', dpid: 0xabc)"
    And sleep 5
    Then a vswitch named "firewall" should be running

  @sudo
  Scenario: Vswitch.create(name: ..., dpid: ..., tcp_port:)
    When I type "vswitch = Vswitch.create(name: 'firewall', dpid: 0xabc, tcp_port: 99999)"
    And sleep 5
    Then a vswitch named "firewall" should be running on port "99999"

  @sudo
  Scenario: Vswitch.create twice and fail
    Given I type "Vswitch.create(name: 'firewall', dpid: 0xabc)"
    When I type "Vswitch.create(dpid: 0xabc)"
    Then the output should contain:
     """
     a Vswitch (name: "firewall", dpid: 0xabc) already exists
     """
