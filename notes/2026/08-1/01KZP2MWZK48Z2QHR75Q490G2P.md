---
id: 01KZP2MWZK48Z2QHR75Q490G2P
created: 2026-08-10T14:53:53.011899Z
updated: 2026-08-11T18:37:57.816354Z
type: task
title: A downgrade override is invisible after it is made — the estate goes quiet and nothing says why
project: 01KX671DATY39VW6GWK3M2T3DN
number: 635
sprint: s1rgnyx
comments:
- id: 01KZR18M8D6VWD8550T5S64V0Z
  author: Steve Vine
  at: 2026-08-11T09:08:11.149362Z
  text: |-
    PR #591. All three acceptance points met, plus a fourth thing worth naming.

    **1. The effective severity now meets the reported one on screen.** New `signal_decision.py` re-states the promotion decision as a read-time projection: `effective_severity`, `opens_incident`, and — when it does not — which of six reasons applies. Two rules it keeps: it mirrors `promote_findings` **in the same order** (a drifting second implementation would explain a decision that was not the one taken), and it reports rather than decides. The queue shows both severities when they differ, never one: `severity` stays what DataDog said, because a downgrade tunes ISE and must not rewrite the source.

    **2. The override layer has a Settings home**, beside the threshold it is compared against. Every row carries the scope in English, who set it, when, why, and **how many live signals it is muting right now**. That last column is the one that would have caught this in a glance — and it deliberately counts only signals the override actually silences, since `critical → high` under a `high` threshold changes the label and nothing else.

    **3. The Downgrade dialog states its real scope before the click** — "'monitor_alert' signals (alerts) from DataDog", the same sentence Settings will then show, built server-side so the two cannot drift.

    **The fourth thing: the badge is deliberately quiet.** It renders only for the *surprising* reasons (`downgraded`, `low_confidence`). `silenced` and `suppressed` already have badges, and `below_threshold` is exactly what the severity pill beside it says. A badge on every row is noise, and noise on every row is how the one that matters gets missed — which is the same failure as the original, wearing different clothes. There is a test asserting an ordinary alert carries *nothing* to read.

    The full explanation still lands in the signal detail drawer for every reason, because that is the box you open when you are already asking the question.

    Deliberately not in scope: [ISE-636] (the override cannot be scoped narrower than a connector's whole alert surface) and [ISE-637] (a downgrade below the threshold is a mute wearing a severity edit's clothes) — both raised out of this and still to be decided.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Found 2026-08-10. Two DataDog monitors sat on the Alerts screen at **High**, last seen "just now", with no open incident. Verified on staging: a single `severity_override` row created **2026-08-05 11:58**, reason *"Used only for testing"*, scoped `system=DataDog, signal_type=alert, kind=monitor_alert → low`, had been muting **every DataDog monitor alert in the estate for five days**.

`auto_incident_policy` is empty, so the threshold is the default `high` (`severity.py:32`). Effective severity resolved to `low`, `should_auto_open` returned False, and the two incidents that had opened on 2026-08-05 (`ff70ac25`, `dedea872`) — resolved by hand that same day — never reactivated. Nothing was broken. Everything worked as designed, invisibly. (Override deleted 2026-08-10.)

**Three verified gaps, each of which alone would have made this visible.**

1. **The effective severity is never shown anywhere.** `effective_severity` is called in exactly one place — `promotion.py:98,215`. The findings API sorts and filters on the raw `Finding.severity` (`api/v1/findings.py:56,142`). So the Alerts row says High, ISE decides on low, and the two numbers never meet on screen. The screen is not wrong so much as answering a different question than the one the operator is asking.

2. **There is no UI for severity overrides at all.** `/api/v1/severity-overrides` (GET/POST/DELETE, `severity_api.py:228-256`) exists in the OpenAPI spec; no frontend file references it — the only hits in `app/frontend/src` are `schema.d.ts` and `openapi.json`. `IncidentPolicyCard` gave the *threshold* a settings home (`SettingsPage.tsx:552`); the override layer that sits on the other side of the same comparison never got one. A rule that silences the estate can be created from the UI but only seen or revoked through the API.

3. **The one-click Downgrade is far wider than it reads.** `downgrade_finding` (`severity_api.py:294`) upserts an override on `(system_id, signal_type, kind)` — every DataDog monitor alert, not the one in front of you. The button says "Downgrade this signal's severity"; the tooltip says "future occurrences". Neither says *all monitor alerts from this system, until someone removes it*, and after the click there is nowhere it appears.

**Scope**
- A severity-overrides surface in Settings alongside the auto-incident policy: what is overridden, to what, scope, who set it, when, why, and a way to clear it.
- Show the effective severity where the decision is actually read — the Alerts row and the signal detail — when it differs from the connector's, with the rule that changed it named. A downgraded signal that opens no incident should say so on its face.
- Make the Downgrade confirmation state the real scope before the click.

**This is the alert-side twin of [ISE-634]**: an operator asks "why is nothing happening?" and the surface answers with a fact about the estate when the true answer is a fact about ISE's own configuration.

**Acceptance**: a High alert that will not open an incident says why on the Alerts screen; every active override is visible and clearable in the app; the Downgrade dialog states the scope it is about to apply.