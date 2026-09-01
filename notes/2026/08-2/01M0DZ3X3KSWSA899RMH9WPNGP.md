---
id: 01M0DZ3X3KSWSA899RMH9WPNGP
created: 2026-08-19T21:33:56.723737Z
updated: 2026-09-01T13:55:50.507553Z
type: task
title: Gate editor — group owner renders blank in edit mode, just a clear-X with no name
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 301
sprint: s5gwx0s
comments:
- id: 01M0K961Z5R4N078QGQ422K6MH
  author: Steve Vine
  at: 2026-08-21T23:06:05.15739Z
  text: |-
    Fixed — PR #336, merged to main. Frontend only.

    `OwnerPicker` takes an optional `seed` — the already-selected person — merged into the search results and deduplicated by id, so the value always has a label to render. `SubjectFieldsEditor` passes COM-279's resolved `group_owners` down, **matched by id** rather than taken as the first, so an editor that has since picked someone else is not seeded with the person it replaced. Both gates get it; they are one component (COM-260).

    **The sweep you asked for turned up a second instance, and a worse one.** The `group_delete` picker in `RaiseRequestModal` is opened pre-filled from `GroupDetailModal` (COM-261), so it held an id no search result matched — a delete confirmation naming no group. It resolves its own selection through `useDirectoryGroup` rather than having a label threaded down through two components, since the id is all it is given and the mirror can answer for it. Fixed here too.

    Confirmed fine and left alone: the business-role MultiSelects (options load unconditionally from `useBusinessRoles`) and `SubjectPicker` in the raise form (always a fresh choice within the modal).

    Both tests were checked against the unfixed code and fail there — the gate editor's owner input reads blank, and the delete picker reads blank.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Smoke finding from Sprint 34 (2026-08-19), follow-up to COM-279. On a `group_create` request awaiting approval, the read-only details now show the resolved owner correctly — but clicking **Edit details** turns the Owner field blank. The value is actually set (the Select shows its clear-X), there's just no visible content, so the approver can't tell who the owner is without discarding out of edit mode — and might reasonably conclude the field is empty and re-pick or clear it.

Mechanism: `OwnerPicker` (SubjectFieldsEditor.tsx) is a searchable Mantine Select whose `data` options come from `useDirectoryUserSearch(query)` — options exist only for what's been typed. Mantine renders a selected value's **label** only when a matching option is present in `data`. The raise form never hits this (the user just searched and picked, so the option is in the list); the gate editor initialises `value = group_owner_ids[0]` with an empty query, so no option matches the stored id and the input shows nothing but the clearable state.

Fix: seed the picker's options with the current owner so the value always renders. The data is already on hand — COM-279 added the resolved `group_owners` (id + name + UPN) to the subject payload precisely for display — so `SubjectFieldsEditor` can pass the resolved owner down as a seed option that `OwnerPicker` merges into its search results (dedup by id). Same treatment for the amend-and-validate editor, which is the same component (COM-260's don't-fork rule). Worth a quick sweep for the same seeded-value gap in the editor's other Selects — business-role MultiSelects are fine (options load unconditionally from `useBusinessRoles`), the search-fed picker is the pattern at risk.

Note the interaction with COM-277: owner is now required, so an approver who "fixes" the seemingly-empty field by clearing it gets a 422 — the guard holds, but the blank field is what invites the mistake.

Refs: COM-279 (the details/edit rework), COM-262 (owner picker), COM-260 (shared gate editors), `access/SubjectFieldsEditor.tsx` (`OwnerPicker`), `access/requestHooks.ts` (`useDirectoryUserSearch`).