---
id: 01M57VTTMS10CXTGV1XJJQ23XQ
created: 2026-10-18T15:59:36.089501Z
updated: 2026-10-19T03:19:25.672937Z
type: task
title: The assistant reaches Attestations — reads what's open and who's compliant, and assigns, changes or stops content on a role, as the person; it never signs for anyone
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1102
sprint: s7s7mn9
blocked_by:
- 01M57VTHCTKR8Q7VVTYS5ZG10M
comments:
- id: 01M592QKDWJ7PRMWX5VEX5HWYX
  author: Steve Vine
  at: 2026-10-19T03:19:24.860354Z
  text: |-
    Done: PR #1092, merged to main.

    - The assistant can say what's open to sign in a company: each role's document, how many have signed, % complete, days left and who's overdue. It can open one round and list everyone in it, including who can't be emailed or can't sign in.
    - It answers "who hasn't signed the AUP?" by listing everyone outstanding or overdue for that document, grouped by role, with due dates.
    - It shows compliance by role, by document and by person, and one person's full history.
    - It lists what a role asks its holders to sign, and which roles assign a document.
    - Someone who manages attestations can, through it, add a document to a role, change the deadline or cadence, and stop or restart it. "Assign the Remote Working Policy to Field Engineers, annually, 14 days" works.
    - Before adding or restarting for today, it tells you every holder will be emailed, and afterwards says how many were asked.
    - Every change shows in Activity as you, via the assistant. It has no way to sign and can't export. A test proves a sign attempt through the assistant is refused.
    - Evidence of operation answers now include the Attestations line on INS.2 and INS.15.

    14 tools in all.

    Calls I made:
    - Listing a role's content, and making changes, also needs the existing permission to view access, because those are role pages. Today only Admin can manage attestations, and Admin has both.

    Found while building, logged as COM-1104: after a mid-round stop and restart for a later date, the role's Content card stops showing the round that's still running. The Open tab still shows it.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 78, Attestations (ADR in COM-1092). The last task; it builds on all the others.

## What people can ask of it

**Read** (with `attestations.view`):
- what's open now, by role or content, with % complete and days left;
- compliance by role, content or person, and a person's history;
- what content a role assigns, and which roles assign a piece of content.

**Do** (with `attestations.manage`), the same as the role's Content tab:
- add content to a role, with assign date, deadline and cadence;
- change the deadline or cadence;
- stop or restart an assignment.

## Rules

- **It never signs**, for the person or anyone else. No signing tool exists, and the portal sign route refuses assistant sessions.
- Adding content with today's assign date emails every holder. The tool says so, and the assistant must say so before calling it, as with vendor questionnaires.
- No exports through the assistant (ADR 0109).
- Everything it changes is in the activity log as the person, via the assistant.

## Notes (technical)

- New `attestations_*` tool module, auto-discovered. Name lookups (role by name, content by title, person by name) go in a shared `attestations_common.py`, like `access_common` and `inventory_common`.
- Add the tools to the server instructions' module list. Run every `test_assistant*.py` before pushing (memory: main is unprotected).

**Done when:** the assistant can answer "who hasn't signed the AUP?" and "assign the Remote Working Policy to Field Engineers, annually, 14 days", and has no way to sign.