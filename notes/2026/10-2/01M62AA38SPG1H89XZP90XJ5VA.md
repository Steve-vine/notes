---
id: 01M62AA38SPG1H89XZP90XJ5VA
created: 2026-10-28T22:32:51.73709Z
updated: 2026-10-28T22:32:51.73709Z
type: task
title: Reviewing in Compass — comments on requests and findings (internal, or shared with auditors), and the auditor's verdicts (accepted, need more, plan accepted, closure accepted) given by an internal audit's auditors or recorded by the audit lead
assignee: steve
label: feature
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1430
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