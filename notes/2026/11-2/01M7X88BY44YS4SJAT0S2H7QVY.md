---
id: 01M7X88BY44YS4SJAT0S2H7QVY
created: 2026-11-20T19:52:09.412229Z
updated: 2026-11-20T19:52:09.412229Z
type: task
title: Polaris links existing evidence by its EVD ID anywhere evidence is taken, including marking a schedule entry done
priority: medium
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2046
---
Built to the ADR in COM-2038, after COM-2045. Today, marking a schedule entry done through Polaris with no file on the entry gets "Upload the evidence on screen first, or give the reason there is none". That's the same dead end Steve hit on screen (2026-11-20).

**What Polaris can do**
- **Find evidence:** by EVD ID, name or words from it, or what's on a control ("what evidence is on RIM.9?"). Answers name each piece by its EVD ID, with its type, period, valid until and status on the control, and a link.
- **Link evidence** that's already in the register to anything that takes evidence: a control, a schedule entry, an incident, a risk, a vulnerability, an audit request, or a finding's closing evidence. Same permissions as on screen. For several at once, it lists them first.
- **Mark a schedule entry done using evidence that's already there:** "Mark SAP-14 done with EVD-12". Linking to the entry also links to its controls (COM-2043).
- **Remove a piece from one record**, saying it stays in the register and anywhere else it's used ("Used in", COM-2040).
- **What it can't do:** upload a file (it can't, in chat). It says to use Add evidence on screen and gives the link.
- Update the existing tools that take evidence (audit_provide_evidence, audit_add_closing_evidence, audit_link_evidence_to_control, sap_complete_entry and others) to accept an EVD ID, and keep the server instructions' wording in step. Mind the 128-tool limit per Copilot area (ADR 0144): extend the existing tools rather than adding one per area where possible.

**Done when**
- Polaris finds evidence by EVD ID and links it to any record that takes evidence, with on-screen permissions.
- "Mark SAP-n done with EVD-n" works.
- Asked to upload, it points to Add evidence on screen.

On the chain: API change (MCP tools).