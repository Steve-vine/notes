---
id: 01M526NZF18K6MMT2F9W3GWWF1
created: 2026-10-16T11:13:44.929372Z
updated: 2026-10-16T13:09:01.399535Z
type: task
title: Rendering placeholders
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1008
sprint: s2ufsxd
assignee: steve
label: null
priority: medium
task_status: backlog
---
In the content read view it currently shows placeholders (Contents, Domain controls) as placeholders. Can these be made to render the actual content on the read tab.

The exception to this is Posture which always shows, and has its own style. Make this behave like Contents and Domain controls, don't automatically show it unless the placeholder has been inserted and then only in-line like the other content.

Currently the Contents placeholder includes a "Contents" heading, none of the other placeholders contain headings, remove the heading, this can be added in the actual content. Going forward, none of the content inserted by placeholders should contain headings.