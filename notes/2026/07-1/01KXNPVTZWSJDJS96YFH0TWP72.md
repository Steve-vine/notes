---
id: 01KXNPVTZWSJDJS96YFH0TWP72
created: 2026-07-16T14:56:33.788667Z
updated: 2026-07-16T18:23:53.920278Z
type: task
title: Issue Loop
assignee: steve
priority: medium
number: 88
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
sprint: s0v93ii
---
In this sprint, create a set of Notuvia tasks that will implement the full process for dealing with issues via the UI within the Issues screen.

### Screen configuration
#### Top section
The screen should be configured with the issue details at the top, this includes the Issue ID, Title, status and tags.  
Next should be the issue (AI) description.
Next the JSON audit information in a collapsed section.

#### Main section
The main section of the screen should contain all the actions and events have happened or been taken during the section, forming a timeline, like a chat.
Each action or text message appears in a bubble style window, much like it does now, but colour coded to easily identify what they are.  E.g. User response - Blue, AI response - grey, action/alert/question - orange, other events - purple.
Each bubble should have a date and time at the top.
Approvals should show as an orange notification, unless the user is an approver in which case there should be an approval acceptance button, that changes to a name and timestamp once accepted.

#### User input panel
The user interacts with the screen via a panel at the bottom of the screen, that has an input box they can type directly into, plus buttons for pre-baked actions like Diagnose and Re-assess
It should also be possible to chat directly with the AI about the issue of the infrastructure.

