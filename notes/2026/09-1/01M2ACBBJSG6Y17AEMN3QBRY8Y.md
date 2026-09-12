---
id: 01M2ACBBJSG6Y17AEMN3QBRY8Y
created: 2026-09-12T08:39:38.329583Z
updated: 2026-09-12T16:16:28.473239Z
type: task
title: Editing an existing asset crashes the page — the owner picker's search and label feed each other in a loop
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 690
sprint: skdc1az
comments:
- id: 01M2AEFQM5P5W4DA6S47DKEJWN
  author: Steve Vine
  at: 2026-09-12T09:16:58.885319Z
  text: |-
    Merged to main in PR #693 (2026-09-12).

    Cause confirmed by a reproducing test: the owner picker held two labels for one person — the record's bare name and the search's "name · job title" — and Mantine's search-echo bounced between them until React threw #185.

    Fix in the shared picker: a found candidate never displaces an already-selected person (one label, decided once), and the Select/MultiSelect own their search text; the picker only listens to drive the candidate query. Covers both modals and the portal edit form, which use the same component.

    Tests: ContainerDetailPage and DataAssetDetailPage each open Edit with a titled owner and a stubbed candidates response, assert the field is not rewritten, no error boundary, and (technology asset) that saving without touching the owner sends the same owner ids. Existing edit tests cover the empty-candidates case.

    Not yet on staging — deploys with the rest of sprint 59. Smoke: Edit on an existing technology asset and data asset; Owner shows the name; typing searches; save without touching the owner leaves it unchanged.
assignee: steve
label:
- bug
priority: urgent
task_status: done
---
Smoke finding, 2026-09-12 (Steve): pressing **Edit** on an existing technology asset or data asset shows the route error boundary ("Something went wrong while drawing it…"). Creating a new one works.

**Evidence** (staging API log, 2026-09-12 08:36Z, two `Client render error` rows): `Minified React error #185` — *Maximum update depth exceeded* — at `/inventory/technology/da2777b0-…` and `/inventory/data/0443a8d7-…`, both from the modal's component tree. The unit tests open the edit modal and pass, because the fixture owner has no job title and no candidate search is stubbed.

**Cause** (COM-678's picker, `inventory/OwnerPickers.tsx`, both modals share it)
1. The modal seeds the owner as `{ value: 'user:<id>', label: owner_name }` — the bare name.
2. `OwnerSelect` controls Mantine's search (`searchValue={query}` / `onSearchChange={setQuery}`). Mantine `Select` has an effect (`Select.mjs` ~L157): whenever the selected option's **label** changes it calls `onSearchChange(label)`. On mount that sets `query = "Alice Owner"`.
3. `useOwnerCandidates("Alice Owner")` now runs; the server returns her with a label built as `"Alice Owner · Payroll Manager"`. `useCandidates` dedupes by value and **keeps the found option's label**, so the selected option's label changes → Mantine sets the search to `"Alice Owner · Payroll Manager"`.
4. That string matches nobody (the server matches name, UPN and title separately; the joined " · " form fails) → `found = []` → options fall back to the seeded `{ label: "Alice Owner" }` → label changes → search back to `"Alice Owner"` → step 3. Once react-query has both results cached the flip-flop is synchronous and React throws #185.
Only when a value is present at mount (edit), only when the person has a job title in the mirror (every real owner), both modals — matches exactly.

**Fix**
* **One label per person, decided once.** When a found candidate has the same value as an already-selected person, keep the *selected* object (its label) rather than replacing it; and seed the selection from the record with the same label shape the search produces (return `owner_job_title` on the asset shapes, or have the seed use name only and the candidates too — but one rule, not two).
* **Stop controlling Mantine's search value.** Let the Select own `searchValue`; use `onSearchChange` only to drive the candidate query, and do not echo the selected label into it. That alone breaks the loop even if labels differ.
* Same for `CoOwnersSelect` (MultiSelect has the analogous effect on value change).
* Also the portal edit form, which uses the same pickers.

**Tests that would have caught it**: render the edit modal with an owner *and* a stubbed candidates response whose label carries a job title, and assert it renders without the boundary and the search box is not rewritten; a second test where the candidates response is empty. Both modals. Then run the existing suites.

**Acceptance**: Edit opens on any existing technology asset and data asset on staging; the Owner field shows the owner's name; typing in it searches; saving without touching the owner leaves it unchanged.