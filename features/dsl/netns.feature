Feature: The netns DSL directive.
  @sudo
  Scenario: phut run with "netns(name)"
    Given a file named "phut.conf" with:
      """
      netns('host1')
      """
    When I do phut run "phut.conf"
    Then a netns named "host1" should be started

  @sudo
  Scenario: ip option (no device)
    Given a file named "phut.conf" with:
      """
      netns('host1') {
        ip '192.168.0.1'
      }
      """
    When I do phut run "phut.conf"
    Then a netns named "host1" should be started
    And the IP address of the netns "host1" should not be set

  @sudo
  Scenario: ip option
    Given a file named "phut.conf" with:
      """
      netns('host1') {
        ip '192.168.0.1'
      }
      netns('host2') {
        ip '192.168.0.2'
      }
      link 'host1', 'host2'
      """
    When I do phut run "phut.conf"
    Then the IP address of the netns "host1" should be "192.168.0.1"
    And the IP address of the netns "host2" should be "192.168.0.2"

  @sudo
  Scenario: netmask option
    Given a file named "phut.conf" with:
      """
      netns('host1') {
        ip '192.168.0.1'
        netmask '255.255.255.0'
      }
      netns('host2') {
        ip '192.168.0.2'
        netmask '255.255.255.128'
      }
      link 'host1', 'host2'
      """
    When I do phut run "phut.conf"
    Then the netmask of the netns "host1" should be "255.255.255.0"
    And the netmask of the netns "host2" should be "255.255.255.128"

  @sudo
  Scenario: mac option
    Given a file named "phut.conf" with:
      """
      netns('host1') {
        ip '192.168.0.1'
        mac '00:00:ba:dc:ab:1e'
      }
      netns('host2') {
        ip '192.168.0.2'
        mac '00:ac:ce:55:1b:1e'
      }
      link 'host1', 'host2'
      """
    When I do phut run "phut.conf"
    Then the MAC address of the netns "host1" should be "00:00:ba:dc:ab:1e"
    And the MAC address of the netns "host2" should be "00:ac:ce:55:1b:1e"

  @sudo
  Scenario: route option
    Given a file named "phut.conf" with:
      """
      netns('host1') {
        ip '192.168.0.1'
        netmask '255.255.255.0'
        route net: '0.0.0.0', gateway: '192.168.0.254'
      }
      netns('host2') {
        ip '192.168.1.2'
        netmask '255.255.255.0'
        route net: '0.0.0.0', gateway: '192.168.1.254'
      }
      link 'host1', 'host2'
      """
    When I do phut run "phut.conf"
    Then the netns "host1" have the following route:
      |     net |       gateway |
      | 0.0.0.0 | 192.168.0.254 |
    And the netns "host2" have the following route:
      |     net |       gateway |
      | 0.0.0.0 | 192.168.1.254 |

  @sudo
  Scenario: vlan option
    Given a file named "phut.conf" with:
      """
      netns('host1') {
        ip '192.168.0.1'
        vlan 10
      }
      netns('host2') {
        ip '192.168.1.2'
        vlan 20
      }
      link 'host1', 'host2'
      """
    When I do phut run "phut.conf"
    Then the VLAN of the netns "host1" should be "10"
    And the VLAN of the netns "host2" should be "20"
