---
id: 01M0Q8TNPNB4WC0J2X8ZPVQ2BX
created: 2026-08-23T12:16:49.877073Z
updated: 2026-08-23T12:16:49.877073Z
type: task
title: Unrequested changes learn who did it — directoryAudits correlation behind AuditLog.Read.All
priority: medium
assignee: steve
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 390
---
The sync knows *that* reality diverged, never *who* diverged it — `unrequested_changes` has no actor columns. Entra's directory audit log has the answer (`GET /auditLogs/directoryAudits`, `initiatedBy` = user or app), and detection's 15-minute cadence + 48h lookback sits comfortably inside the 30-day P1/P2 retention.

- [ ] **Grant**: `AuditLog.Read.All` application permission on the Access app registration (admin consent — ops step; `Directory.Read.All` does not cover audit reads). Add to the verified-app-roles list in `tasks/entra_health.py`, and amend ADR 0045's grant list — it's part of the integration contract.
- [ ] **Columns** on `unrequested_changes`: `actor_kind` (user / app / unknown), `actor_display`, `actor_identifier` (UPN or app id), `performed_at`. Nullable — null means "not yet enriched", shown as such, never conflated with "no actor found".
- [ ] **Correlation**: kind → `activityDisplayName` map ("Add member to group", "Remove member from group", "Add user", "Add group", "Delete group"); filter on `activityDateTime` around `observed_at` + `targetResources/any(t: t/id eq '…')`; a membership item must match **both** the group id and the user id in the targets.
- [ ] **Timing**: attempt enrichment when the item is created, then retry on later sync passes for pending items still missing an actor — audit ingestion can lag minutes to hours. Stop retrying once the item is validated or a bounded age (e.g. 7 days) passes; stamp `actor_kind=unknown` with a reason rather than retrying forever.
- [ ] **Best-effort, loudly degraded**: a missing grant or a failed lookup must never fail the sync pass — the `directory_role_names` None-means-unknown idiom. The API exposes the degraded reason so the UI can say "actor unavailable — audit grant missing" instead of going silently empty.
- [ ] App actors are first-class: "Directory Synchronization Accounts" or a SCIM tool as initiator is signal (the change came from on-prem AD / another IdM), not a failure to resolve a person.

Refs: ADR 0045 §7 (out-of-band detection), ADR 0044 §4 (verified grants), COM-244 (detection), COM-252 (unknown-vs-empty idiom).