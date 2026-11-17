---
id: 01M7NQDJ1BWQZ6H8162HD1RV81
created: 2026-11-17T21:43:12.683768Z
updated: 2026-11-17T21:44:52.513238Z
type: task
title: Polaris drafts, changes and explains flowcharts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1909
sprint: s6y6p7g
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Builds on COM-1908. Steve, 2026-11-17: Polaris can draft and edit flowcharts. It works on drafts, under the same rules as other Content: what the person's role allows on screen, recorded in the activity log as made by them, via Polaris.

**On the canvas: Ask Polaris**
- The canvas gets an **Ask Polaris** panel, like the Workflows builder's. A person types what they want ("add an approval by the Change Manager after the risk assessment", "split this into lanes for Service Desk and Infrastructure", "tidy the No branches"). Polaris **proposes** the change, and the canvas shows it marked up (added, changed, removed) for the person to **Keep** or **Discard**. Nothing is saved until they keep it and save.
- **Draft from text:** in an empty flowchart, "Draft from a description" takes a few sentences. In a document, "Draft from this document" offers the document's sections to draw from (e.g. the steps of a procedure). Polaris lays it out with lanes and decisions where the text names who does what and where it branches, and links steps to controls and documents it's confident about. Each link is marked "suggested" until the person keeps it.

**In chat and Copilot**
- Polaris can create a standalone flowchart as a draft, change a flowchart's draft (standalone, or a document's own), and add a flowchart to a document's draft. Publishing follows the same rule as for any Content today.
- Polaris reads a flowchart as its steps, lanes, branches and links, so it can answer "who approves a major incident?" or "which steps aren't linked to a control?".
- A flowchart Polaris writes in chat is laid out tidily when it's first opened. Until someone opens it in Compass, PDF and Word say "Not yet drawn", as for text diagrams (COM-1904).
- Polaris never invents controls or documents. A link names an existing one, or it's left out and Polaris says so.

**Done when**
- On the canvas, Polaris proposes a change that the person can see before keeping it, and Discard leaves the flowchart untouched.
- Draft from a description and Draft from this document produce a laid-out flowchart with lanes and decisions, with suggested links marked.
- Through MCP, Polaris can create a flowchart draft, change one, add one to a document's draft and read one. The activity log shows each change as the person's, via Polaris.
- Polaris's instructions and tool descriptions describe flowcharts in today's words.

On the chain: new Polaris tools and an API for proposals.