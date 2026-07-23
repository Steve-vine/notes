---
id: 01KY7VY5WSRG871MCTHZPY55AQ
created: 2026-07-23T16:11:33.145153Z
updated: 2026-07-23T16:44:14.57193Z
type: task
title: Dependancy graph enhancements
project: 01KX671DATY39VW6GWK3M2T3DN
number: 231
sprint: s5khymf
assignee: steve
priority: medium
task_status: active
---
Stack the connector information vertically rather than horizontally. E.g.
Currently on a connector it might say “depends on (Asserted)”
Change that to 
Depends on
(Asserted)

Also make the depends on (and anything else that goes in here) a pill, like Asserted.
Make all connector labels on top of the connector line.

Add an arrow to the end of the connectors to explain the relationship E.g.
Asset-A —— (Depends on)——>Asset-B