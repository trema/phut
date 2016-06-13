Feature: phut run command
  Scenario: pid_dir doesn't exist error
    When I run `phut run --pid_dir foo phut.conf`
    Then the exit status should not be 0
    And the output should contain "error: No such directory: foo"

  Scenario: log_dir doesn't exist error
    When I run `phut run --log_dir foo phut.conf`
    Then the exit status should not be 0
    And the output should contain "error: No such directory: foo"

  Scenario: socket_dir doesn't exist error
    When I run `phut run --socket_dir foo phut.conf`
    Then the exit status should not be 0
    And the output should contain "error: No such directory: foo"
