---
id: 01M5B0KXDEQW7K3KK0RX35PC0R
created: 2026-10-19T21:20:55.726717Z
updated: 2026-10-20T18:05:46.179984Z
type: task
title: The assistant can work Data Subject Requests as the person — read and log requests, record checks, decisions and fulfilment, draft letters, log disclosures — but never sees restricted requests and never marks a letter sent
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1147
sprint: ss8348q
blocked_by:
- 01M5B0JZSG582CAEXKKC2M1GNN
comments:
- id: 01M5BVBCM4HNEJE1QZ2WVEEX1V
  author: Steve Vine
  at: 2026-10-20T05:08:07.940202Z
  text: |-
    Done — merged in two parts (PR #1138 and PR #1142). The assistant now has 70 tools for Data Subject Requests.

    - **Reads**: the register (with its filters) and a request's whole page — details, deadline, retention, Verify, Decisions, Fulfil, accounting, Tell recipients, Letters, the close checklist, linked requests, file names, timeline and history; the Disclosures log and requests to disclose; Compliance figures for any period; Settings; the retention periods and log.
    - **Writes**, as the person and under their permissions: log a request and change its details, owner, law and types; pause, restart, extend (with a reason) and recalculate; record identity and authority checks; decide each part with reasons; record what was done in each system and what was provided; record recipients told or not told; work the accounting (period, leave out / put back, add to response); add comments; log and correct disclosures and requests to disclose (and decide one only if they didn't log it); change Settings if they manage them; close a request when its checklist is complete, close it another way with a reason, reopen within 30 days, add a correction; place a legal hold with a reason.
    - **Letters**: it drafts, revises or discards a letter from the company's templates and hands back the text to review. **It never marks a letter sent** — there's no tool for it and Compass refuses it from the assistant — so it can only close a request once a person has marked the final letter sent on screen.
    - **Restricted requests don't exist to it**, even for someone named on one: lists say "plus N restricted", a reference to one reads as not found, and the same goes for disclosures and requests to disclose about that person. This is enforced by Compass, not just the tools.
    - It can't lift a legal hold, change retention periods or clear anything early.
    - Every change shows in History as the person, via the assistant.

    Along the way it fixed two places where a restricted disclosure's name could show (a close-card correction target, and the accounting's "earlier accounting" note). It also found two more: the request timeline (logged as COM-1148, backlog) and the retention log on screen (COM-1150, being fixed before the staging deploy).
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint 79, Data Privacy (ADR in COM-1129). The last task. It follows ADR 0109: the assistant works as the person and only if their role allows. It mirrors how Incidents and Attestations got their tools.

## What the assistant can do

- **Read**: the register (with its filters), a request's page (every card), the Disclosures log and requests to disclose, the Compliance figures, Settings (rules, reasons, templates, retention), and the retention log.
- **Write**, the same as on screen and under the same permissions:
  - log a request;
  - change its details, owner, law and types;
  - pause, restart and extend (with a reason);
  - record identity checks;
  - decide each part with reasons;
  - record fulfilment outcomes and what was provided;
  - record recipients told or not told;
  - add timeline comments;
  - **draft a letter**: fill a template, and return the text for the person to review;
  - log disclosures and requests to disclose, and decide a request to disclose when the person is the approver;
  - close a request, when the checklist is complete;
  - change Settings, for those who can.
- Every write appears in History as made by the person through the assistant, as elsewhere.

## What it can't do

- **See restricted requests, or anything linked to them**, even when the person is named on them. They don't exist to the assistant, and counts say "plus N restricted".
- **Mark a letter sent.** That is a statement that the person sent something from the privacy mailbox, so it stays a human act on screen.
- Apply a retention clearance early, or remove a legal hold.

## Notes (technical)

- `assistant/tools/dsr_*.py` (register, request, verify, decide, fulfil, recipients, letters, disclosures, settings, compliance), helpers in `dsr_common.py`, added to `_HELPERS`. Register each tool with `compass_tool` and its permissions.
- Restriction filtering at the API, as for incidents (ADR 0116 §10).
- Update the tool count wherever it is pinned in tests or docs.

**Done when:** through the assistant, a person can log and work a request end to end except marking letters sent; restricted requests are invisible to it.