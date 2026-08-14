---
id: 01M00JXZZWS8XZ65M3KSZPVNHR
created: 2026-08-14T16:50:52.540692Z
updated: 2026-08-14T20:04:39.526597Z
type: task
title: Frontend — Data Rubric admin tab and data-type pick-lists
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 207
sprint: sbph5q5
blocked_by:
- 01M00JXJKRBNBV1S2WK3DDTJVP
comments:
- id: 01M00SBMAKC1CCAM99064933JG
  author: Steve Vine
  at: 2026-08-14T18:43:10.803821Z
  text: |-
    Shipped. PR #203 squash-merged to main as 34bb0c5.

    Scope changed during the sprint: the data-type pick-lists across the six vendor screens landed in COM-206 (#201), not here. Renaming the engagement payload to data_type_ids and returning resolved rows is a breaking contract change, so those six files stopped compiling — leaving them behind would have made #201 red, and a PR is the only gate. This task became the new Admin surface alone.

    Delivered: Admin > Data rubric, with the sensitivity scale on top (fixed four levels, editable wording, per-row save, history modal — the maturity-rubric pattern) and the data-type vocabulary beneath (add / edit / disable / delete). The empty state carries the weight it needs to, since Compass seeds no data types and this is the first thing every deployment's admin sees.

    One deviation worth noting: the guarded-delete refusal is shown inline next to the row as well as through the global toast. The 409 body ("in use by N engagements — disable it instead") is the actionable half, and relying on a toast alone would make a refused delete look like a dead button.

    Test note for future work: Mantine's Modal marks sibling portals aria-hidden, so a Select dropdown opened inside a modal falls outside the accessibility tree and needs { hidden: true } on the role query. That cost some time to find — the options were present in the DOM with the right text the whole time.

    Frontend suite 245 green, tsc + eslint clean.

    Original PR #202 was auto-closed by GitHub when COM-206's branch was deleted on merge; #203 is the same commit rebased onto main.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Frontend half of the Data Rubric (ADR 0042).

**New Admin tab: "Data Rubric"** (`pages/AdminPage.tsx`, new `admin/DataRubricSection.tsx`) — two stacked sections, modelled on `admin/MaturityRubricSection.tsx`:
* **Sensitivity** (top) — the four fixed levels in rank order, each with an editable name and definition, saved per row, with the revision history modal the maturity rubric already has. No add, no delete: the scale is fixed.
* **Data types** (below) — table of name, definition and a **sensitivity selector**. Add, edit, disable/re-enable, delete (guarded — the API answers 409 "in use", which the UI should surface as an offer to disable instead). **Starts empty**, so the empty state matters: it is the first thing an admin sees, and it should say what data types are for and that engagements can't record data until some exist.

**Data types become a multi-select** everywhere they are captured today — six files currently handle the free-text field:
* `vendors/RequestVendorModal.tsx`, `vendors/RequestEngagementModal.tsx`, `vendors/AmendEngagementModal.tsx` — the onboarding and portal request flows
* `vendors/detail/cards.tsx` — the engagement display; show each type with its sensitivity, and the engagement's effective sensitivity
* `vendors/OnboardingRequests.tsx` — the internal review of a submitted request
* `vendors/ApprovalAreas.tsx` — the rule editor: the `data_types_any` multi-select gives way to a **single sensitivity threshold** selector, presented like the existing `min_criticality` rule

Only **active** data types appear in the pick-lists; a disabled type already recorded against an engagement still renders (historical records stay readable) but can't be newly selected.

**Tests:** the rubric edit + history path; add/disable/guarded-delete; the empty state; a request modal submitting type ids; the rule editor producing a `min_sensitivity` rule; a disabled type rendering on an old engagement but absent from the picker.

Blocked by COM-206 — needs the API and the regenerated `schema.d.ts`. (Offline regen: strip the stdout log lines before `openapi-typescript`.)

Refs: ADR 0042, 0039, 0028, 0018, 0017, 0026.