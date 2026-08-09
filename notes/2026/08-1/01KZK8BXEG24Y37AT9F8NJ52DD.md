---
id: 01KZK8BXEG24Y37AT9F8NJ52DD
created: 2026-08-09T12:36:06.736548Z
updated: 2026-08-09T14:31:18.485064Z
type: task
title: Editing a connection profile opens a blank 'New connection profile' modal
project: 01KX671DATY39VW6GWK3M2T3DN
number: 627
sprint: sesjg7z
comments:
- id: 01KZKEYV6NF2CCEB1M5GBPJ8KF
  author: Steve Vine
  at: 2026-08-09T14:31:18.484807Z
  text: |-
    BUILT 2026-08-09 — PR #571, `feature/ise-627-profile-edit-modal`.

    **Fixed as prescribed**, with one addition the task's own diagnosis implies:

    ```tsx
    <ProfileModal key={editing ? (editing.id ?? 'new') : 'closed'} … />
    ```

    The **closed state is part of the key**, not just the id. Keyed on the id alone, New → cancel → New reuses one mount and shows the abandoned draft — the same class of bug in a different costume, and it would have shipped alongside the fix for it.

    **`AddServerModal` audited and fixed the same way**, as you said it should be rather than left as the one that "does not matter yet".

    **Three tests, each verified to fail with the keys removed** — I pulled them out, watched all three go red, then restored:

    1. Edit shows the profile's current values under the title "Edit connection profile".
    2. **A second Edit shows the SECOND profile.** This one is doing real work: a key that is merely *present*, or keyed on "is open", would still carry profile A's values into profile B and pass test 1.
    3. Add reopens clean after a cancelled draft.

    The severity note was right and worth restating: credential ROTATION for server profiles has no other surface, so this was not a cosmetic bug — ADR 0018 makes rotation first-class and this screen was the only place it could happen.
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Reported by Steve 2026-08-09. Clicking Edit beside a connection profile opens an empty modal titled "New connection profile".

**Cause — a stale `useState` initialiser.** `ProfileModal` in `ServersPage.tsx` does:

```tsx
const [draft, setDraft] = useState<ProfileForm>(form ?? EMPTY_PROFILE)
```

The modal is mounted permanently and shown with `opened={form !== null}`, so it first renders while `form` is still `null` and `draft` initialises to `EMPTY_PROFILE`. A `useState` initialiser runs ONCE per mount — clicking Edit later changes the `form` prop but never re-runs it, so the draft stays empty. The title reads "New connection profile" for the same reason: it is derived from `draft.id`, which is undefined.

**Severity is higher than it looks.** A profile in use cannot be deleted (RESTRICT, and the API refuses while servers reference it), so with editing broken there is no way to change a profile's port, become settings, WinRM auth mode, or to ROTATE its credential — without first moving every server off it. Credential rotation is the one that matters: ADR 0018 makes rotation first-class and this is the only surface that offers it for server credentials.

**Fix.** Key the modal on the profile so it remounts per subject, which is exactly what the sibling modals already do:

```tsx
<ProfileModal key={editing?.id ?? 'new'} form={editing} … />
```

`EditServerModal` and `BulkManageModal` both carry that key and both work; `ProfileModal` was written earlier and never got it.

**Audit the rest of the file while there.** `AddServerModal` has the same shape and a milder version of the symptom: its fields are `useState`-initialised once, so opening Add, typing a hostname, cancelling and reopening shows the previous text. Not broken, but the same trap, and it should be fixed the same way rather than left as the one that "does not matter yet".

**Acceptance**: clicking Edit shows the profile's current values with the title "Edit connection profile"; saving changes only what was edited; entering credential fields rotates the bound credential in place; opening Add after cancelling starts clean.