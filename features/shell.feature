Feature: Shell
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch.create
    When I type "Vswitch.create(dpid: 0xabc)"
    And sleep 5
    Then a vswitch named "0xabc" should be running

  @sudo
  Scenario: Vswitch.create twice and fail
    Given I type "Vswitch.create(dpid: 0xabc)"
    When I type "Vswitch.create(dpid: 0xabc)"
    Then the output should contain "a bridge named vsw_0xabc already exists"

  @sudo
  Scenario: Vswitch#stop 
    Given I type "vswitch = Vswitch.create(dpid: 0xabc)"
    When I type "vswitch.stop"
    Then a vswitch named "0xabc" should not be running
