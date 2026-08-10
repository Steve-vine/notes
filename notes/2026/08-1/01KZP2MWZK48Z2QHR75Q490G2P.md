---
id: 01KZP2MWZK48Z2QHR75Q490G2P
created: 2026-08-10T14:53:53.011899Z
updated: 2026-08-10T14:54:00.496601Z
type: task
title: A downgrade override is invisible after it is made — the estate goes quiet and nothing says why
project: 01KX671DATY39VW6GWK3M2T3DN
number: 635
sprint: s1rgnyx
assignee: steve
label:
- bug
priority: high
task_status: backlog
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