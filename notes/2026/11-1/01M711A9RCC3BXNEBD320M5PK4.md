---
id: 01M711A9RCC3BXNEBD320M5PK4
created: 2026-11-09T20:52:08.588492Z
updated: 2026-11-09T20:52:08.588492Z
type: task
title: 'ADR 0142 amendment: an assistant may add and change Collection integrations and their accounts in chat — the key is only ever entered by a person on screen'
task_status: todo
priority: high
label: brief
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1659
---
Asked for by Steve on 2026-11-09, while testing through the Compass staging MCP. He wanted to set up a Cloudflare Collection integration from the assistant, but found that adding or changing one is on screen only. ADR 0142 says Collection integrations are "defined on screen", and the chat tool `posture_list_collection_integrations` says "Creating or changing one, or its keys, stays on screen."

## The decision to record

- **An assistant may add and change a Collection integration** on behalf of a person with Manage integrations: its name, description, address, sign-in method, paging, extra headers, test read, docs link, logo and owner. It's recorded in Activity as that person, via Polaris, as every assistant write is.
- **An assistant may add an account for a company, rename it, and run its test**, but never with a key. An account added in chat **waits for its key**. A person opens a link and enters the key on screen, and only then is the account tested and read.
- **The key never passes through an assistant**, in either direction. No tool takes a key, password, client secret or username paired with a secret, and no tool returns one or its hint. This keeps ADR 0141's rule (Compass holds keys, write-only) and ADR 0142 §8 ("The key never reaches Polaris").
- **The assistant designs the definition itself** from the service's documentation, under the same rules the on-screen form and Polaris's define job follow: https, a public address, the fixed sign-in and paging lists, GET only, and a test read that works for every kind of key the service issues (COM-1658). Starting Polaris's define job from chat isn't needed: a connected assistant can read the docs itself.
- **Not in chat (my call):** deleting a service or an account, and removing an icon. Deleting breaks the checks that read it, so it stays on screen. Uploading an icon file is on screen too; chat can give a logo address for Compass to fetch.

## Done when

- `decisions/0142-collected-evidence.md` gains a dated amendment section with the points above. The accepted text isn't rewritten (append-only).
- The title line's "defined on screen" is left as it is. The amendment says what changed and why.
- CLAUDE.md's ADR 0142 line notes the amendment.

## Notes

- **Independent:** docs only.
- It relates to ADR 0109 (the assistant works as the person), ADR 0141 §2 (keys write-only) and ADR 0143 (assistants sign in through the browser).