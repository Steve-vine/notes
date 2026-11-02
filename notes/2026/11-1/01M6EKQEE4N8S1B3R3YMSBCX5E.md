---
id: 01M6EKQEE4N8S1B3R3YMSBCX5E
created: 2026-11-02T17:08:19.52419Z
updated: 2026-11-02T17:08:19.52419Z
type: task
title: Polaris reads each free-text advisory once — pulls out the products and versions an NCSC alert, CISA advisory or blog post names, marked as Polaris's reading, shared by every company, so watch lists can match items that have no structured data
assignee: steve
priority: high
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1517
---
Sprint 102, Security Feed (ADR 0139 §6, COM-1510).

## What people see

An item with no structured product data, such as an NCSC alert, a CISA advisory, an entry from an admin's feed, or a vendor advisory with nothing machine-readable, gets **"Products named (read by Polaris)"** on its page:
- e.g. "Ivanti Connect Secure 22.7R2.3 and earlier", "Citrix NetScaler ADC 14.1 before 14.1-29.72";
- each product with the versions it says, or **versions not stated**;
- the sentence it came from, quoted, so a person can check it.

These products are matched exactly like structured ones (COM-1520), but a match from Polaris's reading says so ("Polaris read this advisory as naming FortiOS 7.4").

Other behaviour:
- **Once per item**, never per company. When the source edits the entry, Polaris reads it again.
- If **Polaris is off** or has no provider, nothing is read. Items still show and are searchable, keyword watch lists still catch them, and the item says "Products not read: Polaris is off".
- A manager can **correct** Polaris's reading on an item (add, change or remove a product). The correction is kept, credited to the person, and the item isn't re-read over it.
- **Polaris usage** (Admin ▸ Polaris) shows the cost under "Security Feed", with items read per day.

## My calls

- Polaris never decides whether an item matters to a company. It only reads which products and versions the text names (ADR 0139 §6).
- Expected volume is about 20–30 items a day. On the cheaper models that's pennies a month; on the larger ones, a few pounds.
- The 12-month backfill of prose items (about 2–3k) is read in the background at a capped rate. The Sources tab shows progress.

## Notes (technical)

- One structured-output call per item. Input is the item's plain text (title, summary, body, capped length). Output is `[{vendor, product, versions: [{range or "not stated"}], quote}]`, validated against a schema.
- Map to `vendor:product` the same way COM-1518 maps names: prefer a product already in the vocabulary, otherwise add a new name marked "from Polaris".
- Store the results in `feed_item_affected` with source "Polaris" and the quote. A person's correction is source "Person" and wins.
- The text is untrusted: put it in the prompt as data under a clear delimiter, with instructions that it's never instructions. Treat any output outside the schema as a failure.
- Runs as Compass (system actor), not as a person. Record usage via `polaris_usage` with a "security_feed" feature. A Celery task with a label, a rate cap, and safe to re-run.
- Use the organisation's configured provider and model (ADR 0127).

**Chain:** on the chain (migration + API).

**Done when:** on staging, with Polaris on:
- a recent NCSC advisory naming a product and version shows "Products named (read by Polaris)" with the quote;
- a manager's correction sticks;
- Admin ▸ Polaris shows Security Feed usage.

With Polaris off, the item says products weren't read. (Pre-UAT: may be "Couldn't check" without the AI provider. If so, say what Steve should look at.)