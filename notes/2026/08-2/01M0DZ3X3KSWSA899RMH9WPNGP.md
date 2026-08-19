---
id: 01M0DZ3X3KSWSA899RMH9WPNGP
created: 2026-08-19T21:33:56.723737Z
updated: 2026-08-19T21:33:56.723737Z
type: task
title: Gate editor — group owner renders blank in edit mode, just a clear-X with no name
assignee: steve
priority: medium
label: bug
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 301
---
Smoke finding from Sprint 34 (2026-08-19), follow-up to COM-279. On a `group_create` request awaiting approval, the read-only details now show the resolved owner correctly — but clicking **Edit details** turns the Owner field blank. The value is actually set (the Select shows its clear-X), there's just no visible content, so the approver can't tell who the owner is without discarding out of edit mode — and might reasonably conclude the field is empty and re-pick or clear it.

Mechanism: `OwnerPicker` (SubjectFieldsEditor.tsx) is a searchable Mantine Select whose `data` options come from `useDirectoryUserSearch(query)` — options exist only for what's been typed. Mantine renders a selected value's **label** only when a matching option is present in `data`. The raise form never hits this (the user just searched and picked, so the option is in the list); the gate editor initialises `value = group_owner_ids[0]` with an empty query, so no option matches the stored id and the input shows nothing but the clearable state.

Fix: seed the picker's options with the current owner so the value always renders. The data is already on hand — COM-279 added the resolved `group_owners` (id + name + UPN) to the subject payload precisely for display — so `SubjectFieldsEditor` can pass the resolved owner down as a seed option that `OwnerPicker` merges into its search results (dedup by id). Same treatment for the amend-and-validate editor, which is the same component (COM-260's don't-fork rule). Worth a quick sweep for the same seeded-value gap in the editor's other Selects — business-role MultiSelects are fine (options load unconditionally from `useBusinessRoles`), the search-fed picker is the pattern at risk.

Note the interaction with COM-277: owner is now required, so an approver who "fixes" the seemingly-empty field by clearing it gets a 422 — the guard holds, but the blank field is what invites the mistake.

Refs: COM-279 (the details/edit rework), COM-262 (owner picker), COM-260 (shared gate editors), `access/SubjectFieldsEditor.tsx` (`OwnerPicker`), `access/requestHooks.ts` (`useDirectoryUserSearch`).