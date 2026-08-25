---
id: 01M0AJS8XQY4XKS2AXFBV9X0EJ
created: 2026-08-18T14:00:42.167933Z
updated: 2026-08-25T18:43:22.799495Z
type: task
title: Role matrix detail — required owner, full-width role header, side-by-side group columns, Map button truncation
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 258
order: 2.375
sprint: s5gwx0s
comments:
- id: 01M0BGYQ266K0HZWG8R5SR41K7
  author: Steve Vine
  at: 2026-08-18T22:47:57.766549Z
  text: |-
    Built and merged to main (PR #260, CI green).

    Owner required: create without an owner → 422 naming why ("the owner is recertification's default reviewer"); an update that explicitly clears the owner → 422 "cannot be cleared — reassign it instead". The existing-data story went the way the task steered: no NOT NULL backfill guessing owners — a pre-existing ownerless role still takes unrelated edits (omitted owner_id is untouched), while the screen's Save always sends an owner, nudging strays to completion. The create modal gained a required Owner picker; the detail screen's owner select is no longer clearable.

    Layout: the role's fields now sit as one full-width row — [Name] [Description] [Owner] (Save), description as the wide flexible field — with the group columns below. The picker is the classic two-pane: discovered groups (search + the full scrollable list; slice(0,8) is gone, the hook asks for the server's 200 maximum) on the left, mapped groups on the right. Actions keep their shape: flex-shrink 0 on Map/Refused/remove; long descriptions truncate with an ellipsis + tooltip on both panes — the text yields, the button never does.
assignee: steve
company: null
label:
- improvement
- bug
priority: medium
task_status: done
---
Four refinements to the business-role detail screen (COM-238), from working with it live:

* **Owner becomes required.** Frontend validation plus the API contract (schema + 422) — and decide the existing-data story: roles already saved without an owner shouldn't brick on unrelated edits, so enforce on create and on any save touching the screen (nudging strays to completion) rather than a DB `NOT NULL` backfill guessing owners. Matters beyond tidiness: the owner is the default recert reviewer (COM-241), so ownerless roles quietly weaken campaign assignment.
* **Role box goes full-width.** Today it occupies a corner; lay the role's own fields out as a single row across the top — `[Name] [Description] [Owner] (Save)` — with the group columns below getting the full remaining height. Description as the wide flexible field of the row.
* **Group list and Mapped groups side by side** — available/discovered groups on the **left**, mapped groups on the **right**, the classic two-pane picker. **Show the full group list, not just the first 8** — scrollable full-height column with the existing search filtering it; no arbitrary slice. (With COM-252 widening the mirror, keep this list filtered to security groups — only what the matrix can actually manage.)
* **`(+ Map)` button keeps its shape.** A long group description currently squeezes the action into `(+ Ma…)` — the row's flex lets the button shrink. `flex-shrink: 0` on the action, truncate the *description* with an ellipsis + title/tooltip instead; the text yields, the button never does. Check the same flaw on the mapped column's remove action while in there.

Refs: COM-238 (the screen), COM-241 (why owner matters), COM-257 (pill→modal work landing on the same screen — coordinate to avoid churn); ADR 0022.