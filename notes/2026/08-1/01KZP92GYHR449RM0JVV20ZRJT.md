---
id: 01KZP92GYHR449RM0JVV20ZRJT
created: 2026-08-10T16:46:10.897953Z
updated: 2026-08-10T22:52:50.524982Z
type: task
title: Resolving or closing an incident whose signal is still firing should warn — not block
project: 01KX671DATY39VW6GWK3M2T3DN
number: 646
sprint: s1rgnyx
comments:
- id: 01KZPY1WYW5VVKW8RR1BHP521R
  author: Steve Vine
  at: 2026-08-10T22:52:50.52484Z
  text: |-
    Built and merged to main 2026-08-10 — `5a9a3ae` (PR #588), shipped in the same modal as [ISE-642] because it is the same moment in the operator's hands.

    Warn, never block. When the incident's alert status is `triggered` or `recurring`:

    - **Close** says the signal is still firing and that a NEW incident will open on the next sync — the correlation key is released, so the operator would get a fresh number for the problem they just closed.
    - **Resolve** says the signal will be marked resolved while its source still reports Alert, so the incident and the Alerts screen will disagree until it clears.

    Both stay one click from proceeding. Closing a firing incident is legitimate — the fix is in flight, the alert is known-noisy, the work moved elsewhere — and the point was never to stop it, only to make the consequence visible at the moment of the click. The incident already showed **"Re-firing"** one line above the button; nothing connected the two.

    A recovered signal draws no warning, and there is a test pinning that: a warning that fires when it need not is how operators learn to click through warnings.

    Tests: 2 frontend (a firing close warns and stays enabled; a recovered signal is silent), alongside ISE-642's two on the same modal.
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Observed live 2026-08-10. Two reactivated Kora synthetics incidents were resolved and closed at 16:28:57 and 16:29:02. At **16:30:16** the sync opened two brand-new incidents for the same two monitors, because the monitors were still in Alert.

Nothing warned. The operator is not doing anything wrong — the actions are legitimate and should stay available — but the consequence of taking them *while the signal is still firing* is not visible at the moment of the click.

**The two actions behave differently, and both deserve a word.**

- **Close** releases the correlation key: `promote_findings` builds its live map from `Issue.status != "closed"`, so a still-firing signal becomes a first sight again and opens a fresh incident on the next sync (~2 minutes here). Continuity is *not* lost — `RecallPanel` shows "Seen N times before" with the priors — but the operator gets a new incident number for a problem they just closed, and any work in progress on the old one is now on an archived record.
- **Resolve** does not churn. `resolve_incident_signals` sets only `finding.status`, and sync flips a signal to `recurring` solely when `resolved_at is not None` — so a signal that never stopped firing does not bounce a human's resolution back, exactly as ADR 0025 intends. What it *does* do is mark the underlying signal resolved while the monitor is still in Alert, so the Alerts screen and the incident disagree with the source.

**The screen already knows.** The incident carries the alert-status pill — it read **"Re-firing"** on both of these (`lib/alertStatus.ts`). The information is one line above the button. Nothing connects them: the tooltips are "Mark fixed; also resolves the underlying signal and cascades to merged children" and "Archive a resolved or dismissed incident" (`IssueDetailPage.tsx:103,105`), neither mentioning the still-firing case.

**Scope**
- When the incident's alert status is `triggered` or `recurring`, resolving or closing raises a confirmation that states what will happen — for Close, that the signal is still firing and a new incident will open on the next sync; for Resolve, that the signal will be marked resolved while its source still reports Alert.
- **Warn, never block.** Closing a firing incident is a legitimate act (the fix is in flight, the alert is known-noisy, the work moved elsewhere). The precedent is already in this file: Downgrade and Ignore both open a modal that states the consequence and takes a reason, while Resolve/Dismiss/Close are bare buttons.
- Pairs naturally with [ISE-642] (a resolution note) — the same modal can carry both, and "closed while still firing" is precisely the resolution worth recording.

**Acceptance**: closing an incident whose signal is still firing says so first and states that a new incident will open; the operator can proceed anyway in one click.