---
id: 01M18XC95QS6KPTCGYEP7SMZVN
created: 2026-08-30T08:43:03.735726Z
updated: 2026-09-01T13:55:53.339685Z
type: task
title: Picking a person from a directory search shows their object ID, not their name
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 522
sprint: sz42uhw
comments:
- id: 01M196BJYRQET6Q70AAN4T9HFC
  author: Steve Vine
  at: 2026-08-30T11:19:58.168709Z
  text: |-
    Shipped — PR #531, merged to main as 4a0b242.

    The shared mechanism turned out to already exist. Every directory search is a React Query entry under `['directory-users', q]`, and it still holds the person whatever the search box now says — so `useSearchedPeople()` reads that cache rather than keeping a second one beside it. No state, no effect, nothing to invalidate, and no way for the two to disagree. (The first cut did keep its own `{id → label}` map in a ref; `react-hooks/refs` refused it, and moving it to state traded that rule for `set-state-in-effect` — which was the signal the cache did not belong in the component at all.)

    `withResolvedSelections(options, selected, resolve)` puts back only the *selected* ids the current results have dropped, deduplicated by value with the first source winning. Each picker owns its own label format, which is also what keeps the COM-442 loop shut.

    Three sites, as specified:
    - **People** — the `label: principalUserIds[0]` fallback is gone, and a person seeded from the account the form was opened against is read from the mirror like the seeded group beside it. Tested past one person deliberately.
    - **The Mover's removal warning** — the UPN now comes from the mirror rather than `results.find`, so "disable the account (…)" keeps naming which account.
    - **The recert schedule form** — this one needed more than the cache. Its prefilled `d:` owners have never been searched for, so nothing could label them and the field came up **blank**, not as a GUID: a required field that looks unanswered, with COM-317's prefill undone at the last step. `owner-defaults` already carries their name, so the prefill is listed first — which also settles the label against the COM-442 loop.

    **One honest note.** A plain `Select` masks the missing option today: Mantine keeps its own search text and re-displays it, so the field looks right even with the option gone. The Mover's option test holds that invariant rather than the accident and does *not* fail on main — I said so in the test. What did fail without the fix: the People field's GUID pills, the seeded principal, the Mover's warning, and the recert prefill.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Search the directory for a person in a Mover or membership-change request, pick them, and the field fills with a raw GUID instead of their name. The request is still correct — the right id is submitted — but the requester cannot read back who they just chose, and an approver reading the form sees the same thing.

## Why

Every one of these pickers builds its option list *only* from the current search results. Once the query moves on, the person who was picked is no longer among them, and Mantine falls back to rendering the raw value — which is the object id.

The query does move on, immediately, because the search box is controlled (`searchValue`/`onSearchChange`) and Mantine writes to it on select: a `Select` sets the search text to the chosen option's label, a `MultiSelect` clears it. Either way the next render searches for something that doesn't match the person, `data` comes back without them, and the label has nothing to resolve against.

This is the gap COM-301 already found and fixed *in one place* — `OwnerPicker`'s `seed` prop, whose comment describes precisely this failure. The rest of the pickers never got it.

## Two distinct defects

**1. The selected person drops out of `data`.** Affects `OwnerPicker` when used without a `seed` (`SubjectFieldsEditor.tsx:22`) and the Mover's "Directory account" `Select` (`RaiseRequestModal.tsx:~410`). Same file, same shape: `data={results.map(...)}` with nothing retaining the pick.

Knock-on in the Mover: `selected = results.find((u) => u.id === userId)` goes `undefined` for the same reason, so the orange "Executing this will: disable the account (upn)" warning silently loses the UPN it exists to show — the confirmation of *which* account is about to be disabled.

**2. The fallback option uses the id as its own label.** In the "People" `MultiSelect` (`RaiseRequestModal.tsx:~715`):

```
? [{ value: principalUserIds[0], label: principalUserIds[0] }]
```

That renders a GUID by construction, not as a fallback artefact. It also only covers `principalUserIds[0]`, so with several people picked the rest have no option at all — "one request, however many people" is exactly the case it fails.

## The fix

One shared resolved-label cache, rather than a third bespoke `seed`. Accumulate `{id → label}` for every person the search has ever returned in this form, and build `data` from the union of that cache and the current results. A picked person then keeps their label whatever the query does, for one pick or ten, and the seeded-id case falls out of the same mechanism instead of needing its own branch.

Delete the `label: principalUserIds[0]` fallback with it — a label that is a GUID is never the right answer; if an id genuinely cannot be resolved, it should read as unresolved, not impersonate a name.

## Also check

`RecertPage.tsx:~230` builds `userOptions` the same way. Compass users come from `directory`, which is always present, so those survive; the on-demand `d:`-prefixed directory people have the same shape as the above and likely the same defect. Worth confirming rather than assuming — it is the one site where the bug would only show for some of the options in the list.

## Verifying

Component tests, no backend change: search, pick, assert the field shows the display name (and, in the Mover, that the removal warning still names the UPN); then pick a second and third person in the People field and assert every pill reads as a name. A test that only picks one person passes today against the `[0]` fallback, so it must go past one.
