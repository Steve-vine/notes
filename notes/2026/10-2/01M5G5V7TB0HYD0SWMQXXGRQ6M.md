---
id: 01M5G5V7TB0HYD0SWMQXXGRQ6M
created: 2026-10-21T21:28:30.795535Z
updated: 2026-10-23T18:06:05.676589Z
type: task
title: The assistant can work risk assessments as the person — list and read them, start one, work threats, record DPIA screenings and analyses, import threats and submit — but never approve one or accept a risk
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1242
sprint: s33gwqy
blocked_by:
- 01M5G5QE2SN0S49ZEZ081JC8DR
comments:
- id: 01M5KHM2VSZSQE22Q5HAY197JC
  author: Steve Vine
  at: 2026-10-23T04:52:02.552957Z
  text: |-
    Done — merged in PR #1260 (assistant tools only). Not yet on staging.

    The assistant has 30 risk-assessment tools and works as the person, with their permissions:
    - Read: list assessments (by kind, status or coming due), read one with its threats or cards, its history, the Overview as the tab shows it, the threat catalogue, the Risk to people scale, and the PCI analyses.
    - Work:
      - start any kind, or "the next one" / "Review this DPIA" / "Reassess";
      - edit details;
      - add, change and remove threats (an Accept over appetite is refused, as on screen);
      - import threats from CSV text pasted in the chat, showing the preview first;
      - answer and complete a DPIA screening, and fill in a DPIA, a PCI analysis (including the customised approach) and an AI impact assessment;
      - submit, and withdraw.
    - Never: approve or send back an assessment, approve a risk acceptance, record the ICO's reply or the AI proceed decision, or attach a file. There are no tools for these. Asked to approve, it says who must, on screen, and gives the link.
    - Everything it saves shows "via the assistant" in History.

    Asked "start this year's risk assessment for Moneypenny from last year's", it starts a draft that follows last year's: the same scope, assessors and approver, Why now = Scheduled, and the threats and scores carried forward to work again. A test covers this, and the refusal to approve.

    My calls:
    - The DPIA's prior consultation is read-only to the assistant, including recording what was sent and the extension, because those involve correspondence with the ICO.
    - It can fill in the DPIA's sign-off names and "measures approved", since those are facts the assessors record, not an approval.
    - Marking a PCI requirement as met with the customised approach stays on screen, on the Frameworks page.
    - DPIA and AI follow-ups can't be marked done by the assistant.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 83, Risk Assessments (ADR in COM-1219). ADR 0109: the assistant works in Compass as the person, with their permissions. Built last.

**Chain:** independent (built last)

## What the assistant can do

- **Read:** list assessments (by kind, status, due), read one with its threats or sections, the overview (what's current, due, missing), the threat catalogue and the Risk to people scale.
- **Work:** start any kind; add, edit and remove threats (scores, controls, assets, decision, owner); fill in DPIA screening answers and DPIA sections; fill in PCI and AI impact analyses; import threats from a CSV the person gives it; submit for approval; withdraw.
- **Never:** approve or send back an assessment, approve a risk acceptance, or record the ICO's reply — these stay a person's act on screen, and the tools say so.
- Saves made by the assistant are marked "via the assistant" in History, as for risks today.

## Notes (technical)

- `assistant/tools/risk_assessments.py`, auto-discovered; lookups in a `risk_assessments_common.py`; tool count test updated.

**Done when:** asked "start this year's risk assessment for Moneypenny from last year's", the assistant creates the draft with the threats carried forward; asked to approve it, it explains a person must.