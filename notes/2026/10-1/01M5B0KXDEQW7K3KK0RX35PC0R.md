---
id: 01M5B0KXDEQW7K3KK0RX35PC0R
created: 2026-10-19T21:20:55.726717Z
updated: 2026-10-19T21:21:52.533852Z
type: task
title: The assistant can work Data Subject Requests as the person — read and log requests, record checks, decisions and fulfilment, draft letters, log disclosures — but never sees restricted requests and never marks a letter sent
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1147
sprint: ss8348q
assignee: steve
label:
- feature
priority: medium
task_status: todo
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