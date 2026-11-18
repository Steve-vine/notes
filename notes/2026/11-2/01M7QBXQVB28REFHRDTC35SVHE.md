---
id: 01M7QBXQVB28REFHRDTC35SVHE
created: 2026-11-18T13:00:48.875006Z
updated: 2026-11-18T13:00:48.875006Z
type: task
title: Library search snippets show the document's words, never flowchart or diagram markup
assignee: steve
label: bug
task_status: todo
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1949
---
Found in the Library pre-UAT pass on staging (c15afb4d, 2026-11-18, COM-1920).

**What happened:** searching the Library for "service request handling" showed the flowchart document's snippet as `…flowchart {asset=9469d4d1-499e-4d09-9777-a3dbdc9157d5 caption="E2E…`. That's the stored markup of the flowchart block, not words a reader would recognise. Screenshot: ~/compass-uat/library/COM-1920/11.

**Done when**
- The text the Library searches and quotes from is the document's readable words. That means the same plain text Content's search and plain-text export use. A flowchart contributes its caption and steps, and other non-text blocks contribute their caption or nothing.
- No snippet, in the Library or from Polaris's Library search, shows asset ids, block names or attribute syntax.
- A test searches a document with a flowchart, a drawing and a text diagram, and checks the snippet holds only words.

On the chain: changes what the Library's search API returns.