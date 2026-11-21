---
id: 01M7X88BY44YS4SJAT0S2H7QVY
created: 2026-11-20T19:52:09.412229Z
updated: 2026-11-21T09:01:47.328032Z
type: task
title: Polaris links existing evidence by its EVD ID anywhere evidence is taken, including marking a schedule entry done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2046
sprint: s9hexqn
blocked_by:
- 01M7X8812CSRMA4JKM1EVAGWNC
comments:
- id: 01M7YGTE156T3TT9YGMY4ZKN9T
  author: Steve Vine
  at: 2026-11-21T07:41:04.420942Z
  text: |-
    Done and merged to main (PR #2044). No migration.

    What Polaris can do now:
    - Find evidence by its EVD ID, by words from it, or by what's on a control ("what evidence is on RIM.9?"). Each answer gives the EVD ID, type, period, valid until, status, controls and a link. Opening a piece also lists every record it's used in.
    - Link evidence that's already in the register to a control, a schedule entry, an incident, a risk, a vulnerability, an audit request or a finding's closing evidence, with the same rights as on screen. For several pieces at once it lists them and asks first. A piece that's already there is left alone; one the record can't take is named with the reason.
    - "Mark SAP-14 done with EVD-12" works. The piece is linked to the entry, and so to its controls, and then the entry is marked done. The old "Upload the evidence on screen first" refusal now offers an EVD ID, Add evidence on the entry's page (with its link), or the reason there's none.
    - Take a piece off one record and say it stays in the register and everywhere else it's used. Archiving still takes it out of use everywhere.
    - Asked to upload, it says it can't in chat, points to Add evidence on the record's page and gives the link.

    How it fits the Copilot limit: two new general tools (link and unlink), not a pair per area. With find and read, they're offered in the Audit, plan, incidents, posture and vulnerabilities areas. Every area stays under the 128-tool limit; the largest, access, is unchanged at 105. That's recorded as an amendment to ADR 0144.

    Calls for you to overturn:
    - Taking a piece off a record doesn't ask first, because it can be linked again. Linking several asks first.
    - "Mark done with EVD-…" is all or nothing. If any piece is refused, the entry isn't marked done, and the refusal names the piece.
    - The older control-only link tools stay, so nothing already set up breaks.
- id: 01M7YNE7E0BT5YEBV9N23EQWKQ
  author: Steve Vine
  at: 2026-11-21T09:01:47.327659Z
  text: |-
    Couldn't check (pre-UAT, staging 7e04d3f5e). Polaris in Compass needs the AI provider. I checked the tools directly through the Compass-staging connector (it acts as Steve), in E2E Test Company only.

    Checked through the connector:
    - Find by EVD ID: audit_get_evidence "EVD-68" returned the certificate with evidence_id EVD-68, its type, period, valid until, status (Current, Unchecked), link, and "used_in": Control RIM.9 and "Schedule entry: SAP-85 … finished: true". audit_search "EVD-62" found exactly EVD-62. audit_get_control_evidence RIM.9 listed each piece with its EVD ID.
    - "Mark SAP-n done with EVD-n": I made SAP-87 "E2E 20261121 Polaris mark-done check" (review, linked to RIM.8). sap_complete_entry with no evidence was refused: "SAP-87 has no evidence yet. Give evidence already in the register by its EVD ID (evidence=['EVD-12'] …), or give the reason there is none. A new file or web address isn't added in chat: the person adds it with Add evidence on SAP-87 …'s page, https://compass.citops.net/sap/entries/…". With evidence ["EVD-66"] it went to Done: "evidence_linked: EVD-66 …", "Evidence linked to the entry is its controls' evidence too."
    - Existing tools take an EVD ID: audit_provide_evidence with "EVD-67" added it to AUD-1 request E2E-20261121-01. audit_link_evidence_to_control with "EVD-65" linked it to RIM.8.

    Not checked:
    - The two new general tools, audit_link_evidence and audit_unlink_evidence. They aren't in the connector's tool list in this session, and sap_complete_entry's listed parameters don't show "evidence" either (it still worked). The claude.ai connector probably needs its tool list refreshed after this deploy, and Copilot's areas may too.
    - Polaris's own wording in chat ("asked to upload, it points to Add evidence", listing several pieces before linking, take off). Steve: in Polaris on staging, try "link EVD-62 to RSK-125", "take EVD-62 off VUL-3" and "upload this file", in E2E Test Company.
assignee: steve
label:
- feature
priority: medium
task_status: review
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