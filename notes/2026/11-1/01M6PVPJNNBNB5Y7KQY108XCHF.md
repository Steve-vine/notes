---
id: 01M6PVPJNNBNB5Y7KQY108XCHF
created: 2026-11-05T22:01:35.15737Z
updated: 2026-11-05T22:04:13.750373Z
type: task
title: Collected evidence in audits — an audit pack carries each in-scope control's collected captures for the period, and anyone preparing the pack can ask Polaris to look over them first and flag any that no longer support their control
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1612
sprint: s5khbev
blocked_by:
- 01M6PVP383XV2SC1BEYY3920G2
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Sprint "Checks - Coverage and batch work" (COM-1605). Builds on COM-1610 (review queue) and the audit pack (ADR 0122, Audit Management ADR 0133).

## What people see

- **An audit pack includes collected evidence:**
  - for each in-scope control, the capture current during the period from each account, as its readable PDF, with the raw JSON beside it;
  - the "still true on" dates within the period;
  - for checks with a rule, the existing time-passing summary (ADR 0132 §10).
  - The pack's index says "Collected by Compass" for these, with who approved each check.
  - **People's details are left out** of the pack's copies where the check's items are people: names stay, but email addresses and phone numbers are blanked. That's the ADR 0132 "counts only" line applied to captures.
- **Before producing a pack: "Ask Polaris to look over the collected evidence".**
  - It is on demand, never scheduled (Steve).
  - It covers the pack's in-scope controls, shows the cost first, and its results go to the review queue as a batch.
  - For each control, Polaris says whether the period's captures **still support it**, or flags **why not**: "the capture shows MFA for staff but the control also covers contractors".
  - Flags can be accepted, which leaves the pack as it is and adds a note to the pack's index, or acted on (re-create, mark Partly).
  - Producing the pack never waits on Polaris.
- **Audit requests** (Audit Management) can be answered from a collected check: "Use collected evidence" on a request lists the matching captures for the request's controls.

## Notes (technical)

- `core/audit_pack.py`: add the collected captures via `current_during` and the period lineage (COM-1602's storage). Blank personal fields at pack build, not in the stored capture.
- The look-over is a COM-1599 job kind `review_for_audit` (inputs: control text, period, capture samples), with results into `polaris_proposals` as kind `audit_flag`.
- The audit-request hook: `api/v1/audit_requests.py` and `audit_suggest_request_evidence`. The suggestion list should include collected captures.

**Chain:** on the chain (API).

**Done when:** on staging, in E2E Test Company, an audit pack for a period covering a collected check contains its capture PDF and JSON, with email addresses blanked. "Ask Polaris to look over" on the pack returns a batch in the review queue. Without a provider key, that part is Couldn't check. An audit request on that control offers the capture.