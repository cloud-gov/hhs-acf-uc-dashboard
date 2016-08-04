# Storyboard

The storyboard is located at [https://www.pivotaltracker.com/n/projects/1779875](https://www.pivotaltracker.com/n/projects/1779875). It uses a public, free version of the application PivotalTracker.

For working with developers I prefer this tool because it distinguishes three types of work:

1. **Features**: any small bit of engineering work that produces value for the end user of the product. An example of a feature is a story that allows a user to provide feedback on the application.

2. **Bugs**: Fixes for flaws in the way that the product works. These should be things specified by the product stories, that do not work as specified. Software not working as expected that were never implied of specified in features are actually new features, and should be categorized that way. An example of a bug is a form that previously submitted data correctly, but now when the data is saved, it shows up on the page with weird characters in it. This would be a regression bug.

3. **Chores**: These are technical stories that don't impact the end user, but are important for the maintenance of the software. In order to keep technical debt low, a team will spend ~20% of their engineering time on these kind of task. Putting them on the storyboard, makes them transparent and helps keep the whole product team aware of technical needs. An example of a chore is the team improving their deployment scripts. Instead of taking 2 hours to deploy, the new scripts allows the app to be deployed in just 20 minutes.

For product people PivotalTracker is a good tool because the stories have point values. Engineers will collectively point stories, giving product managers and owners visibility into when features and epics will be complete.

In my experience PivotalTracker is poor at tracking work that happens outside the strict flow of stories through an engineering pipe. For example QA work is hard to track in the app. Also ideation typically has a separate board and doesn't represent the design work naturally.
