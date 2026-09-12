---
id: 01M2A8PF0Y7XBCQDA86PVADZ9P
created: 2026-09-12T07:35:47.998343Z
updated: 2026-09-12T09:22:47.815937Z
type: task
title: Technology asset support — an "End of support" date replaces the Support status field; in or out of support is derived
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 685
sprint: skdc1az
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
Decided with Steve, 2026-09-12: a typed support status goes stale the day after it is set. The fact worth recording is **when support ends**; whether the asset is in or out of support follows from today's date.

**The record**
* `support_status` (`in_support | extended_support | end_of_life | unknown`) is **replaced** by two columns on `containers`: `support_ends_on` (date, nullable) and `support_unknown` (bool, default false). Exactly one of "a date" or "unknown" is the normal state; both empty means *not recorded*.
* **Derived support status**, computed in the API and returned on every technology asset shape (list, detail, portal, CSV export) as `support_state`:
  * date in the future (today inclusive) → **In support**
  * date in the past → **Out of support**
  * Unknown → **Out of support** (not knowing is the risky case; it must not read as fine)
  * neither recorded → **Not recorded** (shown dimmed; counts with Out of support anywhere a number is reported — the dashboard tile, filters — because an unanswered question is not evidence of support)
* Migration (append-only, one head): add the two columns; backfill `end_of_life` → `support_unknown = true`; `unknown` → `support_unknown = true`; `in_support` / `extended_support` → nothing (no date is known, so they become *not recorded* — logged with counts so the owners can be asked); drop `support_status`. The Postgres enum stays (cannot be dropped) but nothing references it.

**The form** (technology asset modal, internal and portal — the owner is accountable for this field)
* A single **End of support** field: a date picker with an **Unknown** switch beside it (checking Unknown clears and disables the date). Description: "When the vendor stops supporting this version. Unknown counts as out of support."
* The detail page shows *End of support: 31 Mar 2027 · In support* / *Unknown · Out of support* / *Not recorded* as one `Fact`; the register list gains a **Support** pill column (green In support / red Out of support / dimmed Not recorded) sortable by the derived state then date.
* Filters: a **Support** filter on the technology assets tab (In support / Out of support).
* CSV: the template column becomes `end_of_support` (ISO date or the word `unknown`); the importer accepts either; `support_status` is no longer a column.
* Dashboard tile: **Out of support** count (unknown and not recorded included), linking to the tab filtered to Out of support — feeds vulnerability management, the reason the field exists.
* Review-due logic unchanged; an End of support date passing does not itself raise an action (revisit if Steve wants one).
* ADR 0072 §1 field list amended; `labels.ts` `SUPPORT_LABELS` replaced by the three derived labels.

Tests: derivation at the boundaries (today = in support, yesterday = out, unknown = out, blank = not recorded), the migration's mapping and log, form round-trip both ways (date ↔ unknown), CSV both spellings, the tile count. Regenerate `schema.d.ts`.

**Acceptance**: the modal has one End of support field with an Unknown option and no Support status select; a date next year reads In support, last year reads Out of support, Unknown reads Out of support; the register filters and the tile count on the derived state; existing end-of-life assets come through as Unknown.