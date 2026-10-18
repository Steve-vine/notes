---
id: 01M57VSAVDZNB1HE3N99211QTG
created: 2026-10-18T15:58:47.14911Z
updated: 2026-10-18T22:38:40.754569Z
type: task
title: Publishing a new version of assigned content asks "sign again now, or at the next cycle?" — now opens a fresh round for everyone it's assigned to
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1098
sprint: s7s7mn9
blocked_by:
- 01M57VQQ6XGNJ86QW7CNXP1XBM
- 01M57VRYJ5HD7W69433HKDCCGN
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 78, Attestations (ADR in COM-1092; Steve's decision: the publisher chooses). Builds on who-is-due (COM-1094) and the emails (COM-1097). It answers INS.2's "again when the policy changes materially".

## What people see

When someone publishes a new version of content that is assigned to at least one role, in any company, the publish window adds a choice:

- **Ask everyone to sign again now**, for a material change. The window says how many people in how many roles will be asked, e.g. "212 people across 9 roles, in 2 companies".
- **At the next cycle**, for a minor change such as a typo or formatting. People sign the new version when their role's cadence next comes round.

The choice is required: there's no default, so it's a decision rather than a reflex. Content that isn't assigned anywhere publishes exactly as today, with no extra question.

**Sign again now:**
- opens a round straight away for that document, for every holder of every role it's assigned to. Each role's deadline is counted from today;
- signatures on older versions no longer count;
- the opening email goes out (COM-1097);
- the role's Content tab and the Open view show it as a round "opened by new version 5".

**At the next cycle:** nothing changes until each role's next cycle opens. That cycle asks for version 5 or later.

The content's version history records which was chosen, by whom.

## Rules

- A one-off assignment still re-asks on "Sign again now". That's the point of the choice.
- Assignments that are stopped aren't re-opened.
- The assistant can publish only if it already can (ADR 0109). If so, it must make the same choice explicitly and never default it.

## Notes (technical)

- Hook the content publish path (UI and `playbook_publish_content`) for a `resign` flag that is required when the item has active assignments. A 422 without it keeps API callers honest.
- The round is an extra cycle per assignment with its own opened-at and version. It doesn't shift the regular cadence.

**Done when:** publishing assigned content forces the choice; "now" re-asks everyone with fresh deadlines; "next cycle" waits.