---
id: 01KXY6M0B5VPR0QNG1YPSXAS48
created: 2026-07-19T22:05:49.797816891Z
updated: 2026-07-24T12:32:39.165055Z
type: task
title: Escalate an open incident when its signal's severity rises
project: 01KX671DATY39VW6GWK3M2T3DN
number: 152
sprint: sohzsw2
comments:
- id: 01KY4SPVRX0ZJTW59WQM6BN08E
  author: Steve Vine
  at: 2026-07-22T11:34:52.957027Z
  text: |-
    Done — PR #190 (feature/ise-152-incident-escalation), branched from main and independent of the Sprint 19 stack.

    **Diagnosis confirmed exactly as written in the task.** `promote_findings` had two automatic transitions — open (no live incident) and reactivate (resolved + recurring) — and nothing anywhere in `promotion.py` mutated an existing incident's severity. Severity was only ever set at construction, in `_new_issue`.

    **Fix.** New `_escalate()` in `promotion.py`, called on the live-incident branch. A firing, above-threshold signal whose effective severity (ADR 0026 — the tuned value, not the connector default) exceeds its live incident's re-grades it: severity raised, title refreshed from the signal, `incident_escalated` audit row recorded against the incident with `{from, to, alert}`. `promote_findings` now returns a third counter, `escalated`.

    Restructured the `elif finding.status == "recurring"` branch into a plain `else` with reactivation then escalation in sequence, so an incident reactivated by the same pass is live and re-grades on the way through. Verified by test.

    **De-escalation: deliberately not built**, as you suggested. Two reasons, both in ADR 0040 §2 — escalation is *information* (the estate is worse than the record says) while de-escalation is a *judgement* ADR 0025 reserves for the operator; and a symmetric rule would reintroduce flapping through the back door, since a monitor oscillating Warn↔Alert would swing the incident's queue position every sync. Consequence worth knowing: severity is now a high-water mark for the incident's lifetime, not a current reading.

    **Which states escalate** — open / acknowledged / reactivated. Resolved is exempt (re-grading half-undoes a human's decision while leaving it in the resolved queue) and dismissed stays sticky. Both pinned by tests.

    **Master/child.** Escalation lands on the master per ADR 0035 §4, with the entry naming the child. But the master's **title is not** rewritten — severity belongs to the merged problem, the title names that specific incident, and overwriting it with a child's alert name would silently rename the operator's incident. Title refresh is safe in the normal case because no endpoint lets a human author an issue title (checked `issues.py` — there's no title PATCH), so nothing authored gets clobbered.

    **ADR 0040** written, as you anticipated — it refines ADR 0025's "the durable record does not flap with the signal" by naming the one direction in which it does follow. Also records that de-escalation stays undecided and would need its own ADR, being the first automatic downgrade of a human-owned record.

    **"Re-notify" has nothing to hook into.** There is no notification subsystem in ISE — no email, webhook or push; every "notification" is a client-side Mantine toast fired from a user action. So the operator-visible surface for a re-grade is the severity itself (which drives the queue badge and the severity filter) plus the timeline entry. Flagged in ADR 0040's consequences as the obvious trigger if notifications are ever built.

    **Frontend.** `describeAudit` in `IssueTimeline.tsx` renders `Escalated medium → high - Low Disk Space`. Both grades named deliberately — "Escalated" alone leaves the reader to guess how far, and the point of the line is that the queue now says something different. Not added to `ALERT_LIFECYCLE_ACTIONS`, so the ISE-200 flap-folding never hides it.

    **Tests** — 8 new integration in `test_promotion.py`: the prod scenario end to end; the entry names both grades with actor `sync`; idempotence (a re-synced unchanged worse signal escalates once, not every 30s); no de-escalation; resolved exempt; dismissed exempt; recurrence reactivates *and* escalates in one pass; a cleared signal does not escalate. Plus one frontend test. The fixture installs a `medium` auto-open threshold on purpose — the default is `high`, but the incident being fixed opened at medium, which is the whole shape of the bug.

    Three existing tests asserted the counts dict by equality and needed the new `escalated` key.

    Backend 847 passed, ruff + mypy strict clean; frontend 273 passed, lint/build clean.

    **DoD:** a monitor going Warn→Alert re-grades its open incident to high, visible in the queue and as a timeline entry, reproduced deterministically by `test_a_worsening_signal_escalates_its_open_incident`.
label: null
priority: high
task_status: done
---
**Bug (pre-Sprint 14, promotion.py / ADR 0025).** A signal that worsens while its incident is already open never re-grades the incident, so an escalation is invisible.

**Found in prod 2026-07-19.** DataDog monitor "Low Disk Space" (`monitor/248505`) first fired as **Warn** → opened incident **#1000** at `medium`, title "…is Warn". It later escalated to **Alert** → the finding is now `high`/`triggered`, but #1000 is still `open`/`medium`/"is Warn". Result: a High alert on the Alerts screen with **no High incident** — it reads as "the alert never created an incident."

**Cause.** Correlation is by `monitor/{id}` (state-independent — correct for dedup). But `promote_findings` only *opens* (issue is None) or *reactivates* (issue resolved + finding recurring). There is no branch for an **open** incident whose signal's effective severity has risen above the incident's current severity.

**Fix.** Add an escalation path, the mirror of reactivation: when a firing signal's `effective_severity` exceeds its live incident's severity, escalate the incident — bump `severity`, refresh the title, add a timeline note ("escalated medium→high"), and re-notify. Consider de-escalation semantics too (probably NOT auto-lower — leave that to the human, consistent with ADR 0025's human-owned incident). May warrant a short note against ADR 0025 since it extends the incident lifecycle.

**DoD.** A monitor going Warn→Alert re-grades its open incident to high (visible + timeline entry); a fresh sync in a test reproduces the escalation deterministically.