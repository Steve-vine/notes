---
id: 01M711A9RCC3BXNEBD320M5PK4
created: 2026-11-09T20:52:08.588492Z
updated: 2026-11-09T21:06:34.822702Z
type: task
title: 'ADR 0142 amendment: an assistant may add and change a Collection integration''s settings, and run its accounts'' tests to fix them — accounts and their keys are managed only on screen'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1659
sprint: sjvqrdg
comments:
- id: 01M7124NJTKDQDP9N1XKXWREY3
  author: Steve Vine
  at: 2026-11-09T21:06:32.666596Z
  text: |-
    **Done: merged to main in PR #1665.**

    ADR 0142 has a new amendment, "an assistant may set up and fix a service's settings; accounts stay on screen" (2026-11-09):
    - An assistant may add and change a Collection integration's settings: name, description, address, sign-in method, paging, extra headers, test read, docs link, logo address and owner. The form's own rules and refusals apply, and each change is recorded in Activity as the person, via Polaris.
    - An assistant may run an account's test and read its result, including what the service itself said, so it can tell a wrong setting from a wrong key.
    - Accounts are managed only on screen: adding, renaming, keys, usernames and removing. No tool takes or returns a key, username or key hint.
    - Deleting a service and uploading an icon file stay on screen.

    CLAUDE.md's ADR 0142 line now mentions it. Docs only, nothing to look at on staging.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Asked for by Steve on 2026-11-09, while testing through the Compass staging MCP. A Cloudflare Collection integration failed its test because Polaris had picked a test read that only works for personal tokens (COM-1658). Steve wants to be able to resolve problems like that through Claude. Today the chat tool `posture_list_collection_integrations` says "Creating or changing one, or its keys, stays on screen", and ADR 0142 says Collection integrations are "defined on screen".

## The decision to record

- **The split stays as it works today:** the service's settings are built for the person (by Polaris's wizard on screen, now also by a connected assistant), and the person adds the accounts.
- **An assistant may add and change a Collection integration's settings** on behalf of a person with Manage integrations: name, description, address, sign-in method, paging, extra headers, test read, docs link, logo and owner. It's recorded in Activity as that person, via Polaris, as every assistant write is.
- **An assistant may run an account's test and read the result**, including what the service said when it refused. That's what lets it work out what's wrong and fix the settings. The test changes nothing in the service: it's one GET of the test read.
- **Accounts are managed only on screen:** adding, renaming, entering or changing a key or username, and removing. No tool takes or returns a key, username or key hint (ADR 0141 §2; ADR 0142 §8, "The key never reaches Polaris").
- **The assistant works the settings out itself** from the service's documentation, under the same rules as the on-screen form and Polaris's define job: https, a public address, the fixed sign-in and paging lists, GET only, and a test read that works for every kind of key (COM-1658).
- **Not in chat (my call):** deleting a service, because it breaks the checks that read it. Uploading an icon file is on screen too; chat can give a logo address for Compass to fetch.

## Done when

- `decisions/0142-collected-evidence.md` gains a dated amendment section with the points above. The accepted text isn't rewritten (append-only).
- CLAUDE.md's ADR 0142 line notes the amendment.

## Notes

- **Independent:** docs only.
- It relates to ADR 0109 (the assistant works as the person), ADR 0141 §2 (keys write-only) and ADR 0143 (assistants sign in through the browser).