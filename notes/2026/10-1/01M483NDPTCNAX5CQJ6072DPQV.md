---
id: 01M483NDPTCNAX5CQJ6072DPQV
created: 2026-10-06T08:00:45.78606Z
updated: 2026-10-06T11:01:36.880496Z
type: task
title: A new joiner's one-time password vanishes the moment it is revealed — and it's gone for good
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 838
sprint: sme8esk
comments:
- id: 01M48E0GC15C3CKJFPA4TKEY4V
  author: Steve Vine
  at: 2026-10-06T11:01:34.721336Z
  text: |-
    Merged to main — PR #844 (2026-10-06).

    What changed: after clicking Reveal, the orange "Initial passwords — this will not be shown again" box now stays on screen with Copy all until the page is left. The Reveal button goes (there is nothing left to reveal) and coming back later shows neither.

    Technical: the request detail now holds the revealed list (kept against the request it belongs to, since the pop-up swaps requests) instead of the reveal box holding it; the box is drawn while there is a list *or* something to reveal. The refetch after reveal is kept. No API change.

    Test: the existing test answered every fetch with has_unviewed_passwords: true, so it could never see the box vanish. It now answers false after the reveal, waits for that refetch, and checks the password and Copy all are still there. Confirmed failing against the old page, passing with the fix.

    Left for the smoke test: reveal on staging with a real joiner. The joiner whose password was lost earlier still needs a manual reset in the directory — this fix doesn't recover it.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by Steve testing the joiner process on staging, 2026-10-06 (`staging-20261003-0841`).

## What happens

After a new joiner is created, the request page shows **Reveal one-time passwords (viewable once)**. Click it and the box disappears straight away — the password is never readable.

Because revealing destroys the password on the server (by design — it's view-once), it can't be fetched again. **The joiner's initial password is lost** and has to be reset by hand in the directory.

## What people should see

Click Reveal → the orange "Initial passwords — this will not be shown again" box stays on screen, with each account's password and **Copy all**, until the person leaves the page. Coming back later, the box and the button are both gone (already viewed).

## Notes (technical)

Cause found by reading the code; not reproduced locally.

- `useRevealPasswords` (`app/frontend/src/access/requestHooks.ts:218`) has `onSuccess: invalidate`, so the request is refetched as soon as the reveal succeeds.
- The refetched request has `has_unviewed_passwords: false` (the reveal cleared `onetime_passwords_encrypted`), so `RequestDetailPage.tsx:263` — `{request.has_unviewed_passwords && isRequester && <PasswordReveal/>}` — unmounts `PasswordReveal`, and the revealed list held in its local `useState` goes with it.
- Fix shape: the revealed list must outlive the flag flipping. Either hold the revealed list in the page (lift the state above the conditional) and render the box while `has_unviewed_passwords || list`, or keep `PasswordReveal` mounted once it has a list. Still refetch — the request list's "unviewed passwords" indicator should clear.
- Why the test missed it: `RequestsPage.test.tsx:391` ("reveals the one-time passwords exactly once…") stubs the request with `has_unviewed_passwords: true` on every fetch, so the post-reveal refetch never flips the flag. The test must return `false` after `/passwords` has been fetched and assert the password is still on screen once the refetch has landed.
- The shape has been there since COM-240 (`4544ed13`); the API contract (`GET /access-requests/{id}/passwords`, 410 on a second fetch) is right and doesn't change.

## Done when

- Revealing keeps the passwords on screen until the page is left, and Copy all works.
- The test fails against today's code and passes with the fix.
- Checked on staging with a real joiner.