---
id: 01M4ZTDYYN73ASVRXDP60RB1HA
created: 2026-10-15T13:01:10.485875Z
updated: 2026-10-15T13:01:12.931578Z
type: task
title: The assistant can generate the Reports — framework coverage, the Statement of Applicability and the gap, risk and vendor registers — and hands back the figures with a link to the file
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 983
sprint: sadf3j6
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975. Overview batch.

## What people can ask of it

- **Generate any report on the Reports screen**, for a named company, in the formats the screen offers:
  - Framework coverage, for a framework (CSV or PDF);
  - Statement of Applicability, for a framework (CSV or Excel);
  - Gap register (as on screen);
  - Risk register (as on screen);
  - Vendor register, only for people who can read Vendor Management, exactly as the screen shows it.
- **What comes back:** a short summary of what's in it (counts and headline figures), the rows themselves when the report is small enough to read in the conversation, and a **link that downloads the file** from Compass. The link works in the browser for someone signed in.
- **Example:** "Generate Acme's ISO 27001 Statement of Applicability as Excel." The assistant gives the counts of applicable and excluded requirements and the download link.
- The Access Control report library (saved and scheduled reports) belongs to the Access module and is out of scope.

## Notes (technical)

- These wrap `reports.py` (coverage, gaps, vendors, risks) and `soa.py`. The vendor tool is registered with the vendors read permission, so it's hidden without it.
- The tool calls the route for the data (CSV, parsed) and builds the download link to the same route with the chosen format. It returns no binary to the assistant.
- Cap the inline rows (say 200) and say so when truncated, pointing at the file.

**Done when:** on staging, the assistant generates the SoA and the gap register for a company, and both download links open the right file in the browser.