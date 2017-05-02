Feature: The link directive of phut DSL
  @sudo
  Scenario: link name_a, name_b
    Given a file named "phut.conf" with:
      """
      vswitch { dpid 0xabc }
      vhost { ip '192.168.0.1' }
      link '0xabc', '192.168.0.1'
      """
    When I do phut run "phut.conf"
    Then a link between "0xabc" and "192.168.0.1" should be created

  @sudo
  Scenario: link alias_a, alias_b
    Given a file named "phut.conf" with:
      """
      vswitch('my_switch') { dpid 0xabc }
      vhost('host1') { ip '192.168.0.1' }
      link 'my_switch', 'host1'
      """
    When I do phut run "phut.conf"
    Then a link between "my_switch" and "host1" should be created

  @sudo
  Scenario: connect multiple links to a switch
    Given a file named "phut.conf" with:
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
    When I do phut run "phut.conf"
    And I run `phut show 0xabc`
    Then a link between "0xabc" and "host1" should be created
    And a link between "0xabc" and "host2" should be created
    And a link between "0xabc" and "host3" should be created
