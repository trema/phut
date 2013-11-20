Feature: phut command

  @sudo
  Scenario: phut run
    Given a file named ".phuture/config" with:
      """
      PID_DIR: .
      LOG_DIR: .
      SOCKET_DIR: .
      """
    And a file named "network.conf" with:
      """
      vswitch('0xabc')
      """
    When I successfully run `phut run network.conf`
    Then a vswitch named "0xabc" launches

  Scenario: phut --version
    When I successfully run `phut --version`
    Then the output should match /\d+\.\d+\.\d+/

