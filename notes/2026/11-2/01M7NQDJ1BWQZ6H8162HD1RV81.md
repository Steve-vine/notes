---
id: 01M7NQDJ1BWQZ6H8162HD1RV81
created: 2026-11-17T21:43:12.683768Z
updated: 2026-11-18T06:58:39.509958Z
type: task
title: Polaris drafts, changes and explains flowcharts
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1909
sprint: s6y6p7g
blocked_by:
- 01M7NQD62HJTV4MBMB162RQT2G
comments:
- id: 01M7PQ6JSJYZ6PA8GJ9MYV196B
  author: Steve Vine
  at: 2026-11-18T06:58:38.514533Z
  text: |-
    Done — PR #1912, merged faf46f33.
    The flowchart canvas has an Ask Polaris button. Someone types what they want, and Polaris proposes it on the canvas, marked up: steps added (green), changed (orange) and removed (faded, struck through). New links are marked "Suggested", and any link that matched nothing in Compass is listed as left out. Keep takes the proposal (one Undo puts it back); Discard leaves the flowchart untouched. Nothing is saved until Done.
    In an empty flowchart, "Draft from a description" takes a few sentences. In a document, "Draft from this document" lets you tick the document's sections to draw from. Polaris puts in lanes where the text says who does what, and decisions where it branches.
    In chat and Copilot, Polaris can:
    - create a standalone flowchart as a draft;
    - change a flowchart's draft (standalone, or a document's own);
    - add a flowchart to a document's draft, either its own or showing a published standalone one;
    - read any flowchart as its steps, lanes, branches and links (e.g. "who approves a major incident?", "which steps aren't linked to a control?").
    Each change is recorded as the person's, via Polaris. Polaris never invents a control or a document: a link that matches nothing is left out, and Polaris says so.
    Assumptions: on the canvas, keeping a proposal keeps all of it, suggested links included. A flowchart Polaris writes in chat is laid out by Compass in plain layers and lanes, and Tidy up on the canvas refines it. Showing a standalone flowchart in a document needs it published, as on screen.
    To check on staging (needs Polaris switched on): open a flowchart, press Ask Polaris, ask for a change, then try Keep and Discard. Try "Draft from this document" on a procedure. In chat, ask Polaris to read a flowchart, then to create one.
assignee: steve
label:
- feature
priority: medium
task_status: review
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