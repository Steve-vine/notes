---
id: 01M6EKQEE4N8S1B3R3YMSBCX5E
created: 2026-11-02T17:08:19.52419Z
updated: 2026-11-04T07:46:09.109063Z
type: task
title: Polaris reads each free-text advisory once — pulls out the products and versions an NCSC alert, CISA advisory or blog post names, marked as Polaris's reading, shared by every company, so watch lists can match items that have no structured data
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1517
sprint: s6xh9g1
blocked_by:
- 01M6EKMP2TDB3NC3FB8Y64BZRM
- 01M6EKPS3T8QZA757H4PAA9P8H
comments:
- id: 01M6EXW66ARGGAZKG9SD7E3CPS
  author: Steve Vine
  at: 2026-11-02T20:05:40.682394Z
  text: |-
    Done. Merged to main (PR #1534). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What happens now:
    - An item with no structured product data, such as an NCSC alert, a CISA advisory or an entry from a feed an admin added, is read once by Polaris for the products and versions it names.
    - That reading is shared by every company and is clearly marked as Polaris's. On the item page it shows as "Polaris's reading", with the sentence it came from.
    - Watch lists match on it the same as structured data. A match that came from Polaris's reading says so.
    - A person can correct the products on the item page (COM-1522). The correction replaces Polaris's reading and is never overwritten.
    - If Polaris is switched off or can't read an item, the item says so ("Products not read: Polaris is off") rather than staying silent.

    Worth knowing:
    - Reading runs in the background every 15 minutes, up to 40 items each time, so the first load of advisories takes a while to work through.
    - Polaris's usage for this shows under the name "Security Feed".
    - Pre-UAT will probably be "Couldn't check" for the reading itself if staging has no AI provider.
- id: 01M6EXX70YRMKEAKN5P1WH4Z24
  author: Steve Vine
  at: 2026-11-02T20:06:14.301873Z
  text: 'One gap: the Sources tab doesn''t yet show how far the background reading has got. That''s now COM-1530 in this sprint, and it''s being built next.'
- id: 01M6G9Z10HKQG4BQP84WZF5JXT
  author: Steve Vine
  at: 2026-11-03T08:56:11.025479Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed**, one design gap logged.

    - Polaris is on for staging and reading: by 08:40 it had read products from 74 advisories (84 products), and the Sources line says "Polaris has read 80 of 136 advisories … 56 to go".
    - The Cisco notice "Advance Notification for Publication of October 7, 2026, Security Advisories" shows **Products named (read by Polaris)**. Each product (Nexus 3000 and 9000, NX-OS Software, …) has the sentence it came from in quotes, "Versions not stated", "Polaris's reading" as who says so, and a Correct button.

    Found: Polaris (like the sources) names products in its own words, e.g. "nx-os_software" where NVD has "nx-os", so a watch list on one name misses the others. Logged as COM-1536 with a proposal (one product, several names; give Polaris the known names).

    Small thing: an item Compass first saw today shows an "Updated" mark after Polaris reads it. Polaris's reading seems to count as an update.

    Screenshots: ~/compass-uat/sprint-102/COM-1517/
assignee: steve
label:
- feature
priority: high
task_status: done
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