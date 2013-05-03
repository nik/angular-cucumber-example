Feature: Member sees New Brands section
  As a member, in order to discover new brands
  I can view a list of brands I'm not currently participating in

  Scenario: Member sees new brands grid
    Given the brands API request returns the following:
      | id    | name       | slug       | logo      | header_image_url | actions_count | actions_new | crowd_participant |
      | 12345 | Tres Toros | tres-toros | foo-1.jpg | bar-1.jpg        | 15            | 15          | false             |
      | 12346 | Half Foods | half-foods | foo-2.jpg | bar-2.jpg        | 20            | 20          | false             |
      | 12347 | McRonalds  | mcronalds  | foo-3.jpg | bar-3.jpg        | 0             | 0           | false             |
    And I am on the portal page with the following params:
      | hideModal |
      | true      |
    Then I should see the "tres-toros" brand box within the New Brands section
    And the "tres-toros" brand box header should have a background image of "bar-1.jpg"
    And I should see "Tres Toros" within the "tres-toros" brand box
    And I should see the "foo-1.jpg" image within the "tres-toros" brand box
    And I should see "15" within the new actions count badge for "tres-toros"
    And I should see the "half-foods" brand box within the New Brands section
    And the "half-foods" brand box header should have a background image of "bar-2.jpg"
    And I should see "Half Foods" within the "half-foods" brand box
    And I should see the "foo-2.jpg" image within the "half-foods" brand box
    And I should see "20" within the new actions count badge for "half-foods"
    But I should not see the "mcronalds" brand box within the New Brands section

  Scenario: Member sees new brands counts
    Given the brands API request returns the following:
      | id    | name        | slug        | logo      | header_image_url | actions_count | crowd_participant |
      | 12345 | Steak Shack | steak-shack | foo-1.jpg | bar-1.jpg        | 15            | true              |
      | 12346 | McRonalds   | mcronalds   | foo-2.jpg | bar-2.jpg        | 10            | false             |
    And I am on the portal page with the following params:
      | hideModal |
      | true      |
    Then I should see "1" within the brands count of the new brands section
    And I should see "10" within the actions count of the new brands section

  Scenario: Member sees new brands counts zero state
    Given I am on the portal page and have seen the welcome modal
    Then I should see "-" within the brands count of the new brands section
    And I should see "-" within the actions count of the new brands section

  Scenario: Member sees correct action count badge on brands grid
    Given the brands API request returns the following:
      | id    | name        | slug        | logo      | header_image_url | actions_new  | crowd_participant |
      | 12345 | Steak Shack | steak-shack | foo-1.jpg | bar-1.jpg        | 0            | false             |
      | 12346 | McRonalds   | mcronalds   | foo-2.jpg | bar-2.jpg        | 1            | false             |
      | 12347 | Dairy King  | dairy-king  | foo-3.jpg | bar-3.jpg        | 2            | false             |
    And I am on the portal page with the following params:
      | hideModal |
      | true      |
    And I should see "1" within the new actions count badge for "mcronalds"
    And I should see "2" within the new actions count badge for "dairy-king"
    But I should see the new actions count badge for "dairy-king"

  Scenario: Member sees action notification tooltips
    Given I am not participating with the following brands:
      | id    | name        | slug        | actions_new | actions_in_progress | actions_expiring |
      | 12345 | Steak Shack | steak-shack | 15          | 10                  | 5                |
    And I am on the portal page with the following params:
      | hideModal |
      | true      |
    When I hover over the new actions count badge for "steak-shack"
    Then I should see a tipsy tooltip containing "New"
    When I hover over the in-progress actions count badge for "steak-shack"
    Then I should see a tipsy tooltip containing "In progress"
    When I hover over the expiring actions count badge for "steak-shack"
    Then I should see a tipsy tooltip containing "Expiring"
