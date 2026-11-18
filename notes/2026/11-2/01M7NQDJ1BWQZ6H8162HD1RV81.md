---
id: 01M7NQDJ1BWQZ6H8162HD1RV81
created: 2026-11-17T21:43:12.683768Z
updated: 2026-11-18T08:12:37.227351Z
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
- id: 01M7PVE1FB9N1GWXWNTHDH9J77
  author: Steve Vine
  at: 2026-11-18T08:12:37.227123Z
  text: |-
    Pre-UAT on staging faf46f33 — Failed (one defect: "Draft from this document" is hidden on a new flowchart in a document)
    Canvas as E2E Admin A in E2E Test Company; MCP as Polaris (acting as Steve). Polaris's AI was on.
    - Ask Polaris proposes, and Discard leaves it untouched: on "E2E pre-UAT COM-1909 Drafted from a description" I asked for an approval by the Security Manager and a rename. The canvas showed it marked up (data-review: 1 added in green, 1 changed in orange, plus a new lane), with "Polaris proposes … Steps: 1 added, 1 changed" and Keep / Discard. Discard put the canvas back exactly ("Request closed" unchanged, no new step). A first draft-from-description was also Discarded and left the canvas empty. Passed.
    - Draft from a description: an empty standalone flowchart offered it. It produced Service Desk and Security team lanes, two decisions with Yes/No, and a Suggested link "Check caller's identity → Control ACC.3". A made-up ZZZ.99 was left out, and Polaris said so. Keep, then Done, saved it with the link. Passed.
    - Draft from this document: works, but only once the canvas is empty (see the defect). Ticking the section gave Line manager, Service Desk and Finance lanes and an "Is it damaged?" decision. Kept. No links were suggested; the text names none.
    - DEFECT: Insert ▸ Flowchart… in a document starts with a Start shape, and with that on the canvas, Ask Polaris shows only "Ask Polaris". Neither "Draft from this document" nor "Draft from a description" appears. Once Start is deleted, both appear. Import treats Start-only as empty; Ask Polaris doesn't. Steps: a procedure with text ▸ Insert ▸ Flowchart… ▸ Ask Polaris. Screens 11-draft-from-document-panel.png (only Start) and 12-start-removed.png.
    - Through MCP: read_flowchart gave steps, lanes, branches, links and steps with no control. create_flowchart made "E2E pre-UAT COM-1909 Created through MCP" as a draft (left out QQQ.42 and said so). update_flowchart changed its draft (reword, new step). add_flowchart_to_document added to a document's draft both a published standalone flowchart (shown at v5; read back with shown=true) and its own flowchart. The activity log shows each as "steve.vine@… via Polaris". The MCP-made flowchart opened laid out in lanes. Passed.
    - Instructions and tool descriptions: the five flowchart tools describe Start/End, Step, Decision, Document, Input/Output, Hand-off, Note, lanes, business-role lanes and "never invent a link" in today's words. Passed.
    Observations: in the first draft, Polaris's chat said a note was "linked to the published access-control-policy", but the proposal carried no link and listed no suggested link. "Left out, as nothing in Compass matched" didn't show for ZZZ.99 (it was only in the summary). The section to draw from is labelled "main".
    Screenshots: ~/compass-uat/s6y6p7g/COM-1909/
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