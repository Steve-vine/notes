---
id: 01M6PVM1EZ9VTQM336YPH4SXFJ
created: 2026-11-05T22:00:11.999014Z
updated: 2026-11-06T02:19:04.296007Z
type: task
title: How each control is covered, and how it's doing — every control, per company, is Fully automated, Partly automated, Manual only or Not yet looked at, and Passing, Failing, Collecting, Held or Broken; a person can mark a control Manual only with a reason; the control page and the SoA show both
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1607
sprint: s5khbev
blocked_by:
- 01M6PVKHAFFRSXDJ263Y0S5MJ0
comments:
- id: 01M6QAE12DATZTGH63DTTMTJX5
  author: Steve Vine
  at: 2026-11-06T02:19:03.629167Z
  text: |-
    Done — merged to main (PR #1623).

    What's there
    - Every control now says how its evidence is collected:
      - Fully automated: a collected or built-in check covers all of it.
      - Partly automated: with what still needs a person.
      - Manual only: with the reason.
      - Not yet looked at.
    - It also shows how it's doing: the worst state across its checks (Broken, Held for review, Failing, Can't tell, Passing, Collecting).
    - "Manual only" can be set by hand on the control's collection card, with a reason, and undone. Polaris's "can't be automated" answer sets it too, once accepted.
    - The Statement of Applicability and the Coverage report carry the same words.

    My calls
    - Built-in checks count too: MFA for admins is "fully" covering, the rest "partly".
    - When a control has several checks, the worst state wins (Broken beats Failing beats Passing).

    Tests: test_collection_coverage.py; CollectionCard tests.

    What to check on staging: open a control with a collected check, then one marked Manual only, and check that the SoA and Coverage report say the same.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on COM-1606. This task is the two answers per control. The page that lists them all is COM-1608.

## What people see

- **Covered**, for each control and company:
  - **Fully automated:** at least one approved check (built-in or collected) says it covers the whole control.
  - **Partly automated:** checks exist but none covers it fully. Shows what still needs a person, from each check's "Partly" note.
  - **Manual only:** Polaris said it can't be automated and a person accepted that, or a person marked it. Always with the reason.
  - **Not yet looked at:** none of the above.
- **Doing**, the worst of its checks, in this order: **Broken**, **Held for review**, **Failing**, **Passing**, **Collecting**. Hovering lists each check's own state.
- **The control's page** (for a company) shows both as pills on the How Compass collects this card, with **Mark as manual only** / **Undo** (Record assessments, a reason required).
- **Built-in checks count too.** Each built-in check (ADR 0132 §8) states how much of its controls it covers. For example, "Admins have MFA" covers CRD.5 Fully.
- **Statement of Applicability and the Coverage report** gain the coverage words beside "Checked automatically", e.g. "Fully automated · passing".
- **Out of scope or unassessed controls** show their coverage too. Coverage is about how evidence is collected, not about posture.

## Notes (technical)

- Compute at read time from checks plus a small `control_collection_coverage` table, for the Manual only marks and their reasons. Don't store the derived values.
- Add `covers: full | partial` and a `partly` note to the built-in `Check` dataclass (`core/checks/__init__.py`), per control key. The catalogue tests pin counts: update them, and run `pytest -q -n 4` with no `-m` (unit suite memory).
- Surfaces:
  - `checks/evidence.py` `control_words()` (used by `api/v1/reports.py` coverage_report and `api/v1/soa.py`);
  - `ChecksCard` on `ControlDetailPage`.
- One function `coverage_for(db, company_id, control_ids=None)` that the next task's page and filters use. It must be fast across all ~700 controls: one query per source, no per-control loops.

**Chain:** on the chain (migration and API).

**Done when:** in E2E Test Company:
- CRD.5 reads Fully automated (built-in check);
- a control with a "Partly" collected check reads Partly, with the note;
- marking another Manual only with a reason shows it, and Undo clears it;
- the SoA export carries the words;
- the coverage function answers for every control in one call, tested on the full library.