---
id: 01M81A3Z4XBBHWJBRZ6Q5EATBT
created: 2026-11-22T09:41:40.125933Z
updated: 2026-11-22T09:42:22.109104Z
type: task
title: The auditor reads a provided register — a read-only table in the auditor portal as it stood on the date provided, with the period's changes and a watermarked PDF
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2095
sprint: ssj8zkq
blocked_by:
- 01M81A3P9ZNH9RGYR8CHYF4TJK
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Registers - Phase 2" (ADR 0167 §6, in COM-2087). Builds on "Provide a register to an audit request" (COM-2094).

## What people see (as the auditor)
- On a request in the auditor portal, a provided register shows beside provided evidence: its name, prefix and "as at 31 Mar 2026".
- Opening it shows:
  - the register's name, description, controls and last review before that date
  - a read-only table of the entries as they stood on that date: every field (including fields removed since, with their values then), archived entries marked, sortable and searchable
  - **Changes during the audit period**: entries added, changed, archived and restored, each with its date; who made a change shows as "the company"
- **Download** gives the register PDF, watermarked for the auditor, their firm and the audit (ADR 0120 §9). **Download all** includes it under its request.
- **The auditor doesn't see**:
  - an entry's links or evidence (to show evidence held on an entry, the company provides that evidence too)
  - any person's name: the owner, editors and Person field values all show as "the company"
  - another company's name: in a shared register's Company field, any company other than the audit's shows as "another company" (the portal carries nothing of the company but its own name and logo, ADR 0133 §6)
  - any other register
- A withdrawn register shows as withdrawn, with its reason, and can't be opened.
- Opening it the first time locks it (ADR 0133 §3). Opening and downloading are in the audit's Activity.
- The auditor's daily email counts a newly provided register like new evidence.

## Implementation notes (technical)
- New read-only portal routes under the auditor portal; add them to the portal routes exact-set test (the writes list doesn't change, and the portal write-routes allowlist isn't touched).
- Render from revisions at the provided moment, with the redactions above applied server-side (Person → "the company", other companies → "another company"). The watermarked PDF uses the same redacted rendering, not the internal export.
- Watermark via the existing download watermarking.

## Done when
- An auditor sees the provided register as at the date provided, with the period's changes, and downloads a watermarked PDF.
- No links, evidence, people's names or other companies' names appear, on screen or in the PDF.
- First open locks it; open and download are in Activity.
- A withdrawn one shows as withdrawn and can't be opened.

On the chain: API (portal routes).