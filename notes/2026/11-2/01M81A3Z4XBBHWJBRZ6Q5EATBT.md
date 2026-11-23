---
id: 01M81A3Z4XBBHWJBRZ6Q5EATBT
created: 2026-11-22T09:41:40.125933Z
updated: 2026-11-23T13:30:05.900495Z
type: task
title: The auditor reads a provided register — a read-only table in the auditor portal as it stood on the date provided, with the period's changes and a watermarked PDF
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2095
sprint: ssj8zkq
blocked_by:
- 01M81A3P9ZNH9RGYR8CHYF4TJK
comments:
- id: 01M849JWX7DH1GQRWZ6BYSB3N9
  author: Steve Vine
  at: 2026-11-23T13:30:04.071836Z
  text: |-
    Built and merged to main: PR #2097 (7a210b51a). No migration. The portal's writes list is unchanged, with one new read-only route.

    What the auditor sees:
    - On a request, the provided register sits beside the evidence, with its name, prefix and "as at 31 Mar 2026".
    - Open shows its description, controls and last review date by then; a read-only table of the entries as they stood, sortable and searchable, with removed fields kept and archived entries marked; and Changes during the audit period, up to the provided moment, including import updates.
    - Download gives a watermarked PDF, and Download all includes it under its request.
    - A withdrawn one shows with its reason and can't be opened or downloaded.
    - The daily email adds a count ("1 register provided"), with no names.

    For Steve to decide: free text reaches the auditor exactly as typed, so a name typed here will be seen:
    - the register's name and description
    - field names and choice labels
    - text, long text and web address values, including entry titles and their earlier values in the changes list
    - the reason given when a register is withdrawn
    Deliberately left out: archive reasons, review comments and the reviewer, import file names, and notes on changes.

    Main remaining exposure: a shared register shows the auditor every entry, as ADR 0167 §6 says. Company fields are redacted, but an entry about another company can still identify it through its title or text. Shared registers are worth checking before providing one.

    Other decisions made while building:
    1. Listing doesn't lock a register; opening, downloading or Download all does. Ordinary evidence locks as soon as it's listed. The ADR says "opened" for registers.
    2. A Download all made before a register was withdrawn can no longer be fetched; the auditor asks for a new one.
    3. Controls shown are those linked by the provided date.
    4. A change to a Person field reads "the company → the company": the auditor can see that it changed, not who to.
    5. The audit period's day boundaries use UK time, because an auditor has no clock of their own in Compass.

    Existing gap, not changed: ordinary evidence withdrawn after a Download all was built stays in that older zip for up to 7 days. Closed for registers only.

    Tested against real Postgres: as at the date with the period's changes and a watermarked PDF; planted names, links, evidence, reasons and comments confirmed present inside Compass, then searched for in the full JSON, PDF text and metadata, file names, and the zip with its index; per-company registers; guessed, removed and other-audit IDs read as not found; first open locks it; open and download in Activity; withdrawn; a revoked auditor; the daily email count. CI and main build green.

    Not checked: the portal screen and the PDF's layout in a browser (pre-UAT pass); the daily email actually being sent; an expired auditor separately (same sign-in check as revoked); two auditors opening at the same instant.
assignee: steve
label:
- feature
priority: high
task_status: review
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