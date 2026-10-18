---
id: 01M54KCN2M5DRF8VCTS0JZD2NN
created: 2026-10-17T09:34:19.732271Z
updated: 2026-10-18T07:50:14.056782Z
type: task
title: The assistant can work the Security Assurance Plan — read and change entries and series, link controls, complete and cancel, comment, raise findings, read coverage and the summary — as the person, with uploads kept on screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1059
sprint: sxflvhs
blocked_by:
- 01M54K629ZG5MVJVZGX3PAHN3E
- 01M54K7WXVGPCGPD43HMDK98PP
- 01M54K9M964BMNH39JC81VADMX
- 01M54KBHACTXED5FXGB0QDW92H
- 01M54KC4GWMFKBAXCYRYDVWHRG
comments:
- id: 01M55K0QZW4J71Z3544VK0EK0F
  author: Steve Vine
  at: 2026-10-17T18:47:03.932444Z
  text: |-
    Done: merged in PR #1058.

    - The assistant has 28 SAP tools. It works as the person, with exactly what their role allows, and every change is marked "via assistant".
    - Reading: the schedule (filtered as on screen), an entry in full, the Overview for a year, Coverage for a framework, a control's Evidence of operation, and a year's sign-off with what has changed since.
    - Changing: add, update and delete entries; repeating series, including changing this occurrence and every later one, and stopping a series; adding the standard plan; marking done, correcting and cancelling; comments; linking controls by control or requirement reference; linking findings; and approving a year (only with the approve permission).
    - Delete, cancel, stop repeating and approve are marked as significant, so an assistant that asks before acting will ask first.
    - No uploads, downloads or exports. If an entry has no evidence, "mark done" is refused with "upload the evidence on screen first, or give the no-evidence reason".
    - Entries are found by SAP number or by words from the title. If more than one matches, the assistant is told which ones; it never guesses.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 75, SAP - Schedule (ADR in COM-1041; suggestion 10). Built last, after every other SAP task, so the tools cover what the screen has.

## What people can ask of it

- **Read (for a named company):**
  - the schedule, filtered as on screen (type, status, owner, overdue, a date range);
  - an entry with its comments, evidence file names, linked controls, findings and history;
  - the Overview summary for a year, the Coverage for a framework, and the year's sign-off and what's changed since;
  - a control's Evidence of operation for the company.
- **Change (with `sap.manage_plan`, or as the entry's owner where the screen allows it):**
  - add, update and delete entries; add a repeating series, change it, stop it;
  - link and unlink controls (found by control ref or requirement ref, as the picker does);
  - mark done (outcome, completion date, and either evidence already uploaded or the "no evidence" reason), correct an outcome, cancel with a reason;
  - add, edit and delete their own comments;
  - raise a gap or risk from an entry, or link an existing one (with that module's permission);
  - add the standard plan.
- **Approve the year's plan** (with `sap.approve_plan`). It's flagged as a significant action, and a client that asks before acting asks first.

## Rules

- The same as on screen, as the person, marked "via assistant" (ADR 0109). Done and cancelled entries refuse the same changes the screen refuses.
- **No file uploads or downloads**, as in ADR 0109. The assistant lists evidence by name, and the person uploads on screen. A "mark done" that needs evidence the entry doesn't have is refused with "upload the evidence on screen first, or give the no-evidence reason".
- No exports through the assistant this sprint. It can say where the Export is.
- Delete, stop-repeating and cancel are flagged destructive.

## Notes (technical)

- `assistant/tools/sap_*.py` with the `sap_` prefix and one `update_` per object. Add a small `sap_common.py` for lookups: entries are found by their **SAP-NN** reference (from COM-1042), or by title within the company, asking when several match.
- Tools are auto-discovered (sprint 70). Run every `test_assistant*.py` before pushing (memory: main is unprotected).
- Amend the ADR from COM-1041 rather than writing another, unless the scope differs.

**Done when:** every SAP screen action except uploads, downloads and export has a tool that behaves exactly as the screen does for the same person.