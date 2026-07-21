---
id: 01KXNPVTZWSJDJS96YFH0TWP72
created: 2026-07-16T14:56:33.788667Z
updated: 2026-07-21T17:43:55.490005Z
type: task
title: Issue Loop
project: 01KX671DATY39VW6GWK3M2T3DN
number: 88
order: 0.0
sprint: s0v93ii
assignee: steve
priority: medium
task_status: done
---
In this sprint, create a set of Notuvia tasks that will implement the full process for dealing with issues via the UI within the Issues screen.

### Screen configuration
#### Top section
The screen should be configured with the issue details at the top, this includes the Issue ID, Title and tags, as it is today, but move the status to the far right. The “raised by" line and the assignee, as today.
Next should be the evidence block, but collapsed by default, expand to read.

#### Main section
The main section of the screen should contain all the actions, AI responses and events that have happened or been taken during the session, forming a timeline, like a chat.
Each action or text message appears in a bubble style window, much like it does now, but colour coded to easily identify what they are.  E.g. User input - Blue, AI response - green, action/alert/question - orange, other events - purple.
Each bubble should have a date and time at the top.
Approvals should show as an orange notification, unless the user is an approver in which case there should be an approval acceptance button, that changes to a name and timestamp once accepted.

#### User input panel
The user interacts with the screen via a panel at the bottom of the screen, that has an input box they can type directly into, plus directly above that, buttons for pre-baked actions like Diagnose and Propose remediation, Acknowledge, Resolve, Dismiss.
It should also be possible to chat directly with the AI about the issue, and get responses.

#### The loop
analyse -> diagnose -> propose -> approve -> execute 
The loop is not a strict loop as such, it should be possible to jump about.
**Analyse** - This determines the current state, initially triggered by the error detection itself, but there should be an Analyse button that queries if that state still exists, or has been resolved.
**Diagnose** - Existing button, examines the issue, and if it has access to the affected infrastructure (such as k8s cluster), accesses it to collect additional relevant info.
**Propose** - Existing Propose remediation button, as today, where is can propose an actionable change, this should be resented as an approval, which if the user has permissions to approve, can be done so in the chat.  The user should also be able to discuss this with the AI and refine it if necessary.  In order to get the AI to perform it the user must prompt the AI to propose it again, either via the button or by prompt.
**Approve** - This is the action peformed by an approved user to a proposed change.
**Execute** - One approved, the AI will execute, and post a response once complete, suggesting followup actions.

In short, the Issues screen should essentially work like any other conversation with Claude Code but with the added gateway that an infrastructure change must be officially approved by an authorised user and recorded in the issue screen/log.



