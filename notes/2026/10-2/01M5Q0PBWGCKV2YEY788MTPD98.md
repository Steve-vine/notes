---
id: 01M5Q0PBWGCKV2YEY788MTPD98
created: 2026-10-24T13:13:09.264226Z
updated: 2026-10-24T20:20:31.154672Z
type: task
title: A DDQ answer can cite the Security Assurance Plan — when an exercise, test, review or audit was last done and when it is next due — without giving away its outcome or findings (ADR 0125 amendment)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1283
sprint: ssgnel8
comments:
- id: 01M5QS4QR0JB1Q90QHK5SN56P2
  author: Steve Vine
  at: 2026-10-24T20:20:25.983238Z
  text: |-
    **Done: PR #1301, merged to main.** Goes to staging with the rest of sprint 86.

    **What you'll see**
    - **Citing a plan entry:** an answer or library entry can cite a Security Assurance Plan entry, Public. It reads like "SAP-24 · DR / BC exercise — testing, yearly; planned for 1 June 2027", or "… done on 12 February 2026". Its outcome, findings and comments are never part of it.
    - **What's offered:** entries that aren't cancelled or overdue, plus done ones from the last three years.
    - **A cited entry that changes:** if it's cancelled, falls overdue, is removed or moves date, the answer says so ("… — changed since it was cited: now …") and can't be approved until it's redrafted.

    **Calls awaiting Steve**
    - **Moved dates block approval:** a cited entry that moves date blocks approval, the same as cancelled or overdue.
    - **Three-year window:** done entries older than three years aren't offered.

    **Under the hood**
    - Migration 0687 adds the `sap_entry` source kind.
    - COM-1282's "not in place" and this share one list, `no_longer_citable`, and one pill.
assignee: steve
priority: medium
task_status: review
---
Found running DDQ-3 through the assistant, 2026-10-24. Eight of its questions ask when something was last done or is next due: BC exercises (5b, 5c), IT continuity validation (9b–9g), supply chain validation and review (10b–c, 12b–c). Test Company's plan already holds the answers: a DR/BC exercise on 1 June 2027 (SAP-24), backup restore tests in February and August 2027, and a supplier security review in July 2027. But the plan isn't a source a DDQ answer can cite.

**Steve:** "DDQ answers should be able to source from SAP."

**Decision (ADR 0125 amendment). My calls are marked *.**
- A plan entry is a source of a DDQ answer, on screen and for the assistant. The assistant sees the company's plan alongside the rest of the catalogue (COM-1281).
- What can be given: the entry's title, type, how it repeats, its dates, and whether it is done or planned, so an answer can say "last completed on …" or "next scheduled for …".
- Never given: its outcome, findings, comments or the reason it was cancelled. The same principle as assessments (COM-1282).
- A plan entry counts as Public by rule, like a control*.
- Its evidence files are separate. They can go with an answer only as evidence, under their own classification.
- Cancelled entries can't be cited*.
- A planned entry whose date has passed without it being done (overdue) can't be cited as "next due"*.
- Re-judged live until sending, like controls*. If a cited entry is cancelled, becomes overdue or moves date, the answer flags it and can't be approved until it is redrafted.
- The sent record keeps the entry as it was cited.