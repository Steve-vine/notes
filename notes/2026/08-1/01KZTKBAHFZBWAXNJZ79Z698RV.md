---
id: 01KZTKBAHFZBWAXNJZ79Z698RV
created: 2026-08-12T09:02:42.735568Z
updated: 2026-08-12T15:33:55.162642Z
type: task
title: New dictionary key bug
project: 01KX671DATY39VW6GWK3M2T3DN
number: 659
assignee: steve
label: null
priority: medium
task_status: todo
---
In the tag dictionary when clicking ‘New key’ to add a new key, a blank form is provided in the modal and a new key is created. If ‘New key’ is clicked a second time, the modal is already populated with the previously entered details. Refreshing the page does clear this, and the modal is blank again.