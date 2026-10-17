---
id: 01M4ZTC4CNQPHYZXNMX3YM50PG
created: 2026-10-15T13:00:10.517768Z
updated: 2026-10-16T07:29:10.467242Z
type: task
title: The assistant can read and record Assessments — a company's control status, maturity, owner, evidence links and notes, with each change in the control's history
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 979
sprint: sadf3j6
blocked_by:
- 01M4ZTB9QN2HMD27NERZ3SZTYP
comments:
- id: 01M50TT0B4RAF51H218WRGVSQQ
  author: Steve Vine
  at: 2026-10-15T22:26:59.556052Z
  text: |-
    On staging 2026-10-15 23:26 BST (PR #970). The assistant reads a company's assessment queue (including "Not assessed"), one control's assessment in full with its evidence files as download links, and its history; and records an assessment naming only what changes — everything else is kept. The control page's History tab (and the assessment card) now shows "· via assistant" on saves it made.
    My calls: review dates can't be typed — saving stamps them from the review cadence, as on screen. Maturity can be given as a number or a level name. Owners are found by name or "me"; an ambiguous name is refused.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 70, Content - Build MCP (ADR in COM-974). Built on COM-975, and finds controls through COM-977's lookup. Posture batch.

## What people can ask of it

- **Read, for a named company:**
  - the assessment work-queue, filtered as on screen (not yet assessed, status, maturity, owner, domain, framework);
  - one control's assessment in full: applicable and why, status, maturity, owner, evidence, notes and review dates;
  - its revision history;
  - the names of the files attached as evidence, each with a link to download it.
- **Write (whatever the person's role allows on the Assessments screen):**
  - record or change applicability and its justification, status, maturity, owner, evidence links, notes and review dates.
  - Each save becomes a revision in the control's history, marked via assistant, exactly as a save on screen does.
- **Not through the assistant:** attaching or removing an evidence file (COM-974).
- **Example:** "For Acme, list the Asset Management controls not yet assessed." Then, working through them one at a time: "set AM-02 to Implemented, maturity 3, owner Jo Smith, evidence is the CMDB link."

## Notes (technical)

- These wrap `assessments.py` (the `PUT ""` upsert, the list, get and revisions) and read `assessment_attachments.py`.
- Owners are given by name or email. Resolve them through the same user search the owner picker uses, and refuse an ambiguous name rather than guess.
- Maturity and status take the labels people see (from the rubric, ADR 0018), not internal numbers. The tool description lists them for the company's rubric.
- The revision row needs the via-assistant marker. Confirm COM-975's column covers `assessment` revisions, or add it here in the same migration chain (stack, don't fork the head).
- Assessments feed Compliance figures and suggestions. A save through the assistant must trigger the same follow-on work a screen save does, which it will if it goes through the route. Add a test that the downstream task is queued.

**Done when:** on staging, the assistant records an assessment for one control, and the control page shows the new status, with a revision via assistant.