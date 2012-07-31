brockhill-forecaster
====================

Example rails application showing how to connect to the AgileZen v1 api (requires ruby 1.9.x)

What it does
------------

1. Generate estimates of stories in your backlog in html or csv formats.
2. Push story estimates (in cucumber format) to a project backlog.

Generating estimates
--------------------

You can see the app running live at http://brockhill-forecaster.herokuapp.com
All that is required is an AgileZen API key.

Push stories to a backlog (with estimates)
------------------------------------------

* Break your requirements into individual features using cucumber
* Estimate every scenario (as cucumber features):

  ```cucumber
  Feature: Export data
    A user with viewing privileges
    Can provide selection criteria and export that data to excel

    @8 #this is your estimate for the scenario in hours
    Scenario: Export blended price calculations

    @4
    Scenario: Export field price calculations
  ```

* Store your .feature files in the features_pending directory of your project
* Run the rake task to create stories in AgileZen. Each feature will be imported
as a single story. The 'size' attribute of the story will be the sum of your scenario estimates.

  <pre>
  rake agilezen:push[{api_key},{project_id}]
  </pre>

