Feature: phut command
  Scenario: phut --version
    When I successfully run `phut --version`
    Then the output should match /\d+\.\d+\.\d+/
