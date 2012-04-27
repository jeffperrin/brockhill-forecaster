brockhill-forecaster
====================

Example rails application showing how to connect to the AgileZen v1 api (requires ruby 1.9.x although it could easily be changed to work with 1.8)

This is a little tool I created for doing quick sprint planning using AgileZen. It will assign stories to sprints based on estimated story size (in hours).
It can also export the estimates to .csv format.

The following info is required to use the tool:

1. Your AgileZen API key
2. The ID of the project you wish to forecast
3. The ID of the phase you wish to forecast. This should probably be your backlog phase. (use https://agilezen.com/api/v1/projects/{project_id}/phases.xml?apikey={api_key} to get phase ids)

It's not perfect, for example it breaks down if your story estimates are larger than a couple of days. But it's been fairly useful as a sanity check.

