---
id: 01KY70RWH26ARJ8ZSTDK0J0C08
created: 2026-07-23T08:16:48.162261Z
updated: 2026-07-23T08:16:48.162261Z
type: task
title: React Flow graph improvements
assignee: steve
priority: medium
sprint: s5khymf
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 228
---
### Dependancy graph section
Can this section be given an expand icon to expand the section's height up to the full screen size.
Also add a pop-out icon that opens the section in a new window that can be resized separately.

### Colours
In dark mode the text on the graph elements is light grey on light blue.  Change the text/icon colour to black.

### Nodes
Node connections are a little difficult to read due to 2 things.
- On a node connected to multiple other nodes, all the connections come out of the same point, so on something like Chinwag which currently has about 14 dependancies, there are a lot of overlapping lines coming out of the same single point and running over the top of the Chinwag node.
- Where multiple nodes are connected to the same node, e.g. Chinwag again, the connectors for every node come out of the top of the node, so in a radial view for instance, nodes that are placed above the connecting node have a line coming out of the  top, then curving down, and running back to the next node.

I think the fix for this would be ‘floating edges’ where the handle isn’t at a fixed point.