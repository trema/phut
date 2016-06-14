Feature: Vswitch.destroy
  Background:
    Given I run `phut -v` interactively

  @sudo
  Scenario: Vswitch.destroy
    Given I type "Vswitch.create(dpid: 0xabc)"
    When I type "Vswitch.destroy('0xabc')"
    And sleep 5
    Then a vswitch named "0xabc" should not be running

  @sudo
  Scenario: Vswitch.destroy #=> error
    When I type "Vswitch.destroy('no_such_switch')"
    Then the output should contain:
     """
     Vswitch {:name=>"no_such_switch"} not found
     """

