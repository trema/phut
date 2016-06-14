Feature: Shell
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch#stop 
    Given I type "vswitch = Vswitch.create(dpid: 0xabc)"
    When I type "vswitch.stop"
    Then a vswitch named "0xabc" should not be running
