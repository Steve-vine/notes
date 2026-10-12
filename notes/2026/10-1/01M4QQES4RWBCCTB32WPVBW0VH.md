---
id: 01M4QQES4RWBCCTB32WPVBW0VH
created: 2026-10-12T09:35:16.120535Z
updated: 2026-10-12T10:54:48.689154Z
type: task
title: Read / Live disparities and anomalies
project: 01KY6W9951TW0904DT0GGJVGE7
number: 537
sprint: sd52non
assignee: steve
label: null
priority: medium
task_status: todo
tech: null
---
There seems to be a difference in the way that empty lines are displayed between live and read views.  Review the code base and ensure that they are treated the same way in both views, preferably the standard markdown way.

E.g.

Example 1 - Markdown
This is paragraph 1.

This is paragraph 2. 

Example 2 - Markdown
This is paragraph 1.


This is paragraph 2. 

Example 1 displays the same in both live and read views, however example 2 looks exactly the same as example 1 in read and shows 2 blank lines in live.
I believe read is the correct markdown way.
