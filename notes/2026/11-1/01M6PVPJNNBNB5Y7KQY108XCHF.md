---
id: 01M6PVPJNNBNB5Y7KQY108XCHF
created: 2026-11-05T22:01:35.15737Z
updated: 2026-11-07T08:55:18.906461Z
type: task
title: Collected evidence in audits — an audit pack carries each in-scope control's collected captures for the period, and anyone preparing the pack can ask Polaris to look over them first and flag any that no longer support their control
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1612
sprint: s5khbev
blocked_by:
- 01M6PVP383XV2SC1BEYY3920G2
comments:
- id: 01M6QBSVBEVENC1QBP2ZRJMJD7
  author: Steve Vine
  at: 2026-11-06T02:42:59.56599Z
  text: |-
    Done — merged to main (PR #1628).

    What's there
    - An audit pack now carries each capture that was current during its period as two files: the readable page and the raw data (JSON).
      - Both are rebuilt for the pack with email addresses and phone numbers blanked; names stay.
      - The copy in the Evidence register is never changed.
    - The pack's index says, for each capture: "collected by Compass, check approved by <name>", "still true on <date>", that the copy has personal details blanked, and the fingerprint (SHA-256) of the pack's copy, so an auditor can verify it.
    - "Ask Polaris to look over the collected evidence first" on the New audit pack form:
      - It uses the same framework, controls and period as the pack, and shows the cost before it starts. It only runs on demand.
      - For each control with captures in the period, Polaris says whether they still support it. Each one it thinks doesn't becomes an "audit flag" on Posture ▸ Checks ▸ Review, with why.
      - On a flag: "Accept: note it in the pack" adds "Noted before the pack was made — Polaris flagged: …" to the index of packs for that period. Or open the control to re-create its check or mark it partly automated. Or discard it.
      - Making the pack never waits for Polaris.
    - On an audit request's "Add evidence", captures among the suggestions are marked "Collected by Compass".

    My calls
    - A capture handed to an auditor through a request is the register's copy, not the blanked one; fields marked sensitive are already left out when it's captured. If you want request copies blanked as well, that's a follow-up task.
    - Polaris raises a flag only where it thinks the evidence falls short; "still supports it" adds nothing to the queue.

    Tests: test_collection_audit.py (pack contents, blanking, look-over to flag to note); AuditPacksTab, ReviewTab and ProvidedEvidence tests.

    What to check on staging (E2E Test Company): make a Core controls pack, zip included, for a period covering a collected check. The zip should hold its PDF and "raw data.json" with emails blanked, and the index should say "collected by Compass". The look-over is Couldn't check: it needs Polaris's AI provider.
- id: 01M6RBFXANT82684126FTN094S
  author: Steve Vine
  at: 2026-11-06T11:56:48.340876Z
  text: |-
    Pre-UAT, as E2E Admin B in E2E Test Company, against the real AI provider: Passed, except the audit request part, which is Couldn't check.

    What I saw:
    - **Captures in the pack.** A core-controls pack for ACC.13, 1–6 Nov, holds each capture as a PDF plus "… raw data.json". The index gives SHA-256s and "supports ACC.13", and marks a replaced capture "Replaced on 6 November 2026".
    - **Blanking.** GitHub's `ssh_url` values (`git@github.com:…`, email-shaped) were all replaced by "(left out of the audit pack)" in the pack's copy.
    - **"Ask Polaris to look over".** It previewed "1 control, $0.15", then returned a flag on the Review tab: "ACC.13: may not support the control". It said why: the Entra capture has no principals, the GitHub captures are test data, and the repository and pipeline lists are missing. That's right.

    Small fix (COM-1620): the job was titled "Look over 1 controls".

    Couldn't check: an audit request on that control offering the capture. There's no audit in E2E Test Company.

    Still for Steve, from before: captures given to auditors through audit requests are the register copy, not blanked.

    Pack copy: ~/compass-uat/s5khbev/COM-1612/audit-pack/
assignee: steve
label:
- feature
priority: medium
task_status: done
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