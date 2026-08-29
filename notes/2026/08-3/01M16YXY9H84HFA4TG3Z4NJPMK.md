---
id: 01M16YXY9H84HFA4TG3Z4NJPMK
created: 2026-08-29T14:31:42.129646Z
updated: 2026-08-29T17:17:54.162889Z
type: task
title: Copy button on the new API token
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 512
sprint: s2fcksg
assignee: steve
company: null
label:
- improvement
priority: medium
task_status: active
---
Creating an API token shows the token once and tells you to copy it, but gives you nothing to copy it with — you have to select the text by hand.

`admin/TokensSection.tsx:107-114`:

```tsx
<Text size="sm">Copy this token now — it won&apos;t be shown again.</Text>
<Code block>{secret}</Code>
```

Worse than an ordinary missed convenience, because the plaintext is shown **once** at creation (ADR 0007) and there is no way back if the manual selection clips a character.

## The fix

Same pattern as the reset-password dialog in the sibling modal, `admin/UsersSection.tsx:331-339` — an identical "shown once, never again" moment:

```tsx
<Group gap="xs">
  <Code style={{ fontSize: 16 }}>{password}</Code>
  <CopyButton value={password}>
    {({ copied, copy }) => (
      <Button size="xs" variant="light" onClick={copy}>
        {copied ? 'Copied' : 'Copy'}
      </Button>
    )}
  </CopyButton>
</Group>
```

Mantine's `CopyButton` is already imported and used in three places (`admin/UsersSection.tsx`, `access/RequestDetailPage.tsx:321`, `access/GroupDetailModal.tsx:420`), so nothing new is needed. Use the **labelled-button** form here rather than the icon-only `ActionIcon` variant used for object IDs in `GroupDetailModal` — this is the primary action of the dialog at that moment, not an incidental affordance on a detail row.

One layout note: the token is currently `<Code block>`, which is full-width, so it can't sit in a `Group` beside the button the way the password does. Either drop `block` and use the password dialog's row layout, or keep `block` and put the Copy button beneath it, left-aligned. The token is longer than a password, so keeping `block` and stacking is probably the better read — a judgement call for whoever builds it.

## Worth doing at the same time

The password dialog warns in an `Alert`: *"This is the only time this password is shown. Compass has not stored it — close this dialog and it is gone for good."* The token dialog's one-liner is much softer for the same irreversible moment. Bringing the wording and the `Alert` treatment into line would make the two dialogs consistent, and it's the same edit.

## Verify
Create a token, press Copy, confirm the button reads "Copied" and the clipboard holds the exact token including any prefix. `TokensSection` has no test file today — a small one covering the copy affordance would be reasonable to add alongside.
