brockhill-forecaster
====================

Example rails application showing how to connect to the AgileZen v1 api (requires ruby 1.9.x although it could easily be changed to work with 1.8)

This is a little tool I created for doing quick sprint planning and initial estimates using AgileZen. The following info is required to use the tool:

1. Your AgileZen API key
2. The ID of your project
3. The ID of the phase you wish to forecast. This should probably be your backlog phase. (use https://agilezen.com/api/v1/projects/{project_id}/phases.xml?apikey={api_key} to get phase ids)

It does two things:

1. Assign stories to sprints based on estimated story size (in hours). It can also export the estimates to .csv format.
2. Import stories into an AgileZen backlog from cucumber stories, with estimates

You can estimate by running the app (just like any rails application) and filling out the form on the screen. What I consider to be sensible defaults are provided where applicable.
It's not perfect, for example it breaks down if your story estimates are larger than a couple of days. But it's been fairly useful as a sanity check.

You can push estimates to an AgileZen backlog by creating cucumber feature files in the 'features_pending' directory. Estimates are given by adding cucumber tags to a Scenario
definition like so (the @4 is an estimate of 4 hours):

<pre>
Feature: Export data
  A user with viewing privileges
  Can provide selection criteria and export that data to excel

  @4
  Scenario: Export blended price calculations

  @4
  Scenario: Export field price calculations
</pre>

When you're ready to push your pending features to AgileZen, run the rake task at the command line:

<pre>
rake agilezen:push[{api_key},{project_id}]
</pre>

