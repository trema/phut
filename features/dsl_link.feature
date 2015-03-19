Feature: The link directive of phut DSL
  @sudo
  Scenario: link name_a, name_b
    Given a file named "network.conf" with:
      """
      vswitch { dpid 0xabc }
      vhost { ip '192.168.0.1' }
      link '0xabc', '192.168.0.1'
      """
    When I do phut run "network.conf"
    Then a link is created between "0xabc" and "192.168.0.1"

  @sudo
  Scenario: link alias_a, alias_b
    Given a file named "network.conf" with:
      """
      vswitch('my_switch') { dpid 0xabc }
      vhost('host1') { ip '192.168.0.1' }
      link 'my_switch', 'host1'
      """
    When I do phut run "network.conf"
    Then a link is created between "my_switch" and "host1"

  @sudo
  Scenario: connect multiple links to a switch
    Given a file named "network.conf" with:
      """
      vswitch { datapath_id 0xabc }

      vhost('host1') {
        ip '192.168.0.1'
      }
      vhost('host2') {
        ip '192.168.0.2'
      }
      vhost('host3') {
        ip '192.168.0.3'
      }

      link '0xabc', 'host1'
      link '0xabc', 'host2'
      link '0xabc', 'host3'
      """
    When I do phut run "network.conf"
    And I run `phut show 0xabc`
    Then a link is created between "0xabc" and "host1"
    And a link is created between "0xabc" and "host2"
    And a link is created between "0xabc" and "host3"
    And the output from "phut show 0xabc" should contain "1(0xabc_1)"
    And the output from "phut show 0xabc" should contain "2(0xabc_2)"
    And the output from "phut show 0xabc" should contain "3(0xabc_3)"
