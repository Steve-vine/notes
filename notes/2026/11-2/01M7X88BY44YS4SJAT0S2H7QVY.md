---
id: 01M7X88BY44YS4SJAT0S2H7QVY
created: 2026-11-20T19:52:09.412229Z
updated: 2026-11-21T07:41:26.221878Z
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