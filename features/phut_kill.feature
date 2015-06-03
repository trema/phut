Feature: phut kill command
  Background:
    Given a file named "network.conf" with:
      """
      vswitch { datapath_id 0xabc }

      vhost('host1') { ip '192.168.0.1' }
      vhost('host2') { ip '192.168.0.2' }

      link '0xabc', 'host1'
      link '0xabc', 'host2'
      """
    And I do phut run "network.conf"

  @sudo
  Scenario: phut kill vswitch_name
    When I do phut kill "0xabc"
    And I run `sudo ovs-vsctl list-br`
    Then the output from "sudo ovs-vsctl list-br" should not contain "br0xabc"

  @sudo
  Scenario: phut kill vhost_name
    When I do phut kill "host1"
    And I successfully run `sleep 5`
    Then the following files should not exist:
      | vhost.host1.pid |
      | vhost.host1.ctl |
