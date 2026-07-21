---
id: 01KY2BCHZMT9EB04HP18Z9M0SR
created: 2026-07-21T12:46:06.32412Z
updated: 2026-07-21T12:46:06.32412Z
type: task
title: Master Incidents
assignee: steve
priority: medium
sprint: skj7tft
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 178
---
Create a new feature called Master Incidents.  When merging one incident into another, the incident being merged becomes a ‘Child’ and the incident you’re merging it into becomes the Master.

The relationship between Child and Master is many to one.

When viewing an incident and merging another incident in, make the viewed incident a “Master” incident.
With a master incident it shouldn’t be possible to merge the master into another incident, only able to merge other incidents into the master.

When an incident is a master, display a small ‘M’ style icon next to its ID in the Incidents list and on the incident detail page.
When an incident is a child, display a small ‘C’ style icon next to its ID in the Incidents list and on the incident detail page.

When Incidents are merged into a ‘Master’ incident, instead of closing them, give them a status “Child”.  On the pill for the incident, instead of displaying “Child” display a small icon along with the incident ID of the master.  Clicking on this should open the master ticket.

On the details page of a chid ticket add an option to “Detach from Master”, which removes the master/child relationship to that ticket, display a modal asking the user to select what status the child ticket should be put into before detaching it.

On the details page of a master, create an option to “Demote” which stops the ticket being a master, popup a modal window asking what status the child indents should be set to when detaching them, then remove the master/child relationship.

Maintain a collapsible section on the master incident listing all merged incidents.  For each on provide a link to detach it (with the status modal), and a link to “Promote to Master” which swaps the relationship around and changes all other children to point to that incident as the master.

