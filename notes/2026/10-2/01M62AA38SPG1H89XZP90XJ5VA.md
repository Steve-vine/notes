---
id: 01M62AA38SPG1H89XZP90XJ5VA
created: 2026-10-28T22:32:51.73709Z
updated: 2026-10-29T15:56:09.86158Z
type: task
title: Reviewing in Compass — comments on requests and findings (internal, or shared with auditors), and the auditor's verdicts (accepted, need more, plan accepted, closure accepted) given by an internal audit's auditors or recorded by the audit lead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1430
sprint: swcbxt0
blocked_by:
- 01M62A9PW5C41NCG3W365H3P8X
comments:
- id: 01M6460E85SMY0T6EMCRYDS2Y2
  author: Steve Vine
  at: 2026-10-29T15:56:09.861451Z
  text: |-
    Done — PR #1447 (auto-merge on). Migration 0736.

    What's there: a Review section on every request and finding — the comment thread (Internal by default, Shared with auditors badged, auditors' own comments marked), verdict buttons for an internal audit's named auditors (sending back needs a comment, which is shared), Record the auditor's verdict for the lead on an external audit (with the email attached, filed in the Evidence register, shown "Recorded by X for Y"), and History. The independence warning shows on the audit's Overview and when naming auditors. Need more puts the request back in the owner's Actions with the auditor's words; named auditors get "Review AUD-n request X" items. An audit opened from an Actions link while another company is selected now switches to its company. Findings' closing evidence can be chosen from the register.

    My calls, for you to overturn:
    1. Need more, Plan needs work and Closure not accepted all need a comment.
    2. A named auditor who owns a request or finding can't give a verdict on it (refused, not just warned).
    3. Manage audits alone gives no verdict button; the lead (or Manage audits) can only record one for an external auditor.
    4. Named internal auditors read the whole audit without View audit, but not its Activity trail.
    5. Comments are not in the activity log (correspondence, like a gap's thread); verdicts are.
    6. A recorded verdict's email goes into the Evidence register.
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 97, Audit Management (ADR 0133, COM-1425).

The review steps inside Compass. The portal (COM-1431/1432) gives external auditors the same steps.

## What people see

- **Comments** on every request and finding: a thread with author, time and text.
  - Writing one, a person chooses **Internal** (default) or **Shared with auditors**. Shared comments carry a badge.
  - Internal comments never reach the portal, its emails or any export given to auditors.
  - A shared comment can't be edited after the auditor has seen it, only followed by another.
- **Verdict buttons:**
  - on a request: **Accept** / **Need more** (Need more needs a comment, which is shared);
  - on a finding: **Accept plan** / **Plan needs work**, then **Accept closure** / **Closure not accepted**.
- **Who presses them:**
  - **Internal audit:** the Compass users named as its auditors, for that audit only.
  - **External audit:** the auditors themselves in the portal (COM-1432). The audit lead can also **record the auditor's verdict** when it came by email or in a meeting. It's marked "Recorded by <lead> for <auditor>", with an optional attachment (the email).
- **Independence warning:** on an internal audit, naming as auditor someone who owns a request or finding in it warns "<name> owns 3 requests in this audit". An auditor can't give a verdict on something they own.
- **History** on each request and finding lists every status change, verdict and who gave it.

## Who can do what

- Comments: the owner, *Manage audits*, and the audit's named auditors.
- Verdicts: as above. *Manage audits* alone doesn't let someone accept on an auditor's behalf; they can only *record* a verdict, and it's shown as recorded.

## Notes (technical)

- New tables `audit_comments(target_kind request|finding, target_id, author_user_id | author_auditor_id, shared, body, seen_by_auditor_at)` and `audit_verdicts(target, verdict, by_user | by_auditor | recorded_by, recorded_for_auditor_id, comment_id, evidence_attachment_id)`.
- An auditor's rights on an internal audit come from `audit_auditors.user_id`, checked per audit, with no new permission.
- Status transitions live in one place (`core/audits/status.py`) for requests and findings, so the portal and the screen can't diverge.

**Chain:** on the chain (migration + API).

**Done when:** on staging, an internal audit's named auditor marks one request Accepted and another Need more. The owner sees the shared comment in Actions, and an internal comment is absent from the auditor's view.