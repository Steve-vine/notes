---
id: 01M32YZRFHPYP8P728Q6AHZHEF
created: 2026-09-21T21:47:07.633075Z
updated: 2026-09-22T20:48:45.258153Z
type: task
title: Write the Configuration and Upgrading docs pages
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 3
assignee: steve
label: feature
priority: medium
task_status: todo
---
Both pages are linked from the site footer and the docs sidebar, and both are empty stubs.

Configuration: the settings an operator chooses - sizing, database, attachment storage, public URL, mail, the Vendor Portal's address, Entra ID sign-in - saying which are set at install time and which inside the app.

Upgrading: how to move to a newer release, what happens to the database, how to check it worked, and how to roll back.

Done when: each setting and step has been checked against the chart and the app, not written from memory.

Technical: src/content/docs/docs/configuration.md and upgrading.md. Source is chart/values.yaml, chart/README.md ("upgrade" section) and the release workflow in the app repo. Follows the install guide.