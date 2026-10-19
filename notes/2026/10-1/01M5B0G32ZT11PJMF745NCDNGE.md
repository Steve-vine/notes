---
id: 01M5B0G32ZT11PJMF745NCDNGE
created: 2026-10-19T21:18:50.463442Z
updated: 2026-10-19T21:18:50.463442Z
type: task
title: After a correction, erasure or restriction, Compass lists everyone the data went to — the data assets' vendors and the Disclosures log — and the handler records each one told, or why that wasn't possible, and can give the person the list
task_status: todo
label: feature
assignee: steve
priority: medium
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1138
---
Sprint 79, Data Privacy (ADR in COM-1129). Meets UK/EU GDPR Art. 19 (tell each recipient of a correction, erasure or restriction, unless that is impossible or would take disproportionate effort, and tell the person who they are if asked), and ISO 27701 7.3.7.

## What people see

A **Tell recipients** card. It appears when a correction, erasure or restriction is granted.

**Recipients** are listed from:

- the **vendors** recorded as recipients on the data assets in Fulfil (Inventory's data asset recipients, with their DPA reference);
- **Disclosures log** entries naming this person, or a group that includes their kind of person, in the period the data was held. Named entries are listed first; group entries are offered as suggestions.

The handler can add others (a vendor, or typed).

For each recipient:

- **Told**: when, how (email, portal, letter, phone), and who told them. A "Recipient notification" letter is available (Letters task).
- **Confirmed**: optionally, when the recipient confirmed they had acted.
- **Not told**: the reason, either **Impossible** or **Disproportionate effort**, with a note.

**The person asked who the recipients are**: a tick that puts the list in the response letter.

## Rules

- Every listed recipient needs Told or Not told before the request can close (Close task).
- A recipient that is a vendor shows on the vendor's page under a **Privacy requests** count, linking back. This lets an auditor of the vendor relationship see that it's used.

## Notes (technical)

- Recipient rows on the request: source (data asset recipient / disclosure / added), vendor id or typed, outcome, dates.
- Vendor page: a small read-only card or count, gated on `dsr.view`; restricted requests excluded.

**Done when:** an erasure for a person whose data went to two vendors and one logged disclosure lists all three; each can be marked told or not told with a reason; the response can include the list.