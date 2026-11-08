---
id: 01M6X89W3MBST62CJN48NDYDXT
created: 2026-11-08T09:37:16.916257Z
updated: 2026-11-08T11:13:07.51365Z
type: task
title: 'Personal tokens retire from the assistant — a switch-over an administrator ends: tokens keep working for assistants until switched off, people still using one are warned, then refused with how to reconnect'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1646
sprint: sd11qqf
blocked_by:
- 01M6X89D33TEGG73JM98CX3WN6
comments:
- id: 01M6XDSB09CAHV5GAW3E6GDSYK
  author: Steve Vine
  at: 2026-11-08T11:13:06.569017Z
  text: |-
    Done: PR #1661, merged to main.

    What changed: Admin ▸ Connected assistants has a switch, **"Assistants can still connect with a personal token"**. It's on by default.
    - **Turning it off** asks first and says how many people's assistants it will stop. From then on, an assistant using a personal token is refused with how to reconnect ("add Compass again by its address and sign in in your browser"). The token keeps working for scripts that call the API, and assistants that signed in through the browser aren't affected. Nor is the Polaris window.
    - **Turning it back on** works immediately.
    - Both changes are recorded in Activity.
    - While someone's assistant still uses an old token, their Connect page shows "Reconnect your assistant": which token it is, whether it will stop or already has, and to add Compass again using the steps shown.

    Tested: a token-connected assistant works and is listed, and its owner sees the warning. With the switch off, it's refused with the reconnect message, while the same token still reads the API and a signed-in assistant carries on. Turning it back on restores it. Both changes appear in Activity.

    Note for staging: this session's own Compass connection uses a token. I'll move it to the browser sign-in in COM-1648 before anyone turns the switch off.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Steve (2026-11-08): retire personal tokens for the assistant after a switch-over. My call: an administrator ends it, not a date, because releases reach production at Steve's pace and a date could cut people off before the new sign-in is even there.

**Wanted behaviour:**
- A switch on the Admin page, next to Connected assistants: **"Assistants can still connect with a personal token"**. On when this ships.
- While it's on, an assistant connected with a token works as today. The person's Connect page tells them their assistant uses an old token that will stop working, and shows how to reconnect.
- Turning it off asks to confirm and shows how many people are still on a token (from Connected assistants). From then on a token is refused at the assistant's door with a message saying how to reconnect: "add Compass again by its address and sign in in your browser". Turning it back on is allowed. Both are recorded in Activity.
- Personal tokens keep working for scripts calling the API in every case. Only the assistant's door changes.
- The Polaris window in Compass is not affected.

**Done when:** in E2E Test Company, with the switch on, a token-connected Claude Code works and its owner sees the warning on the Connect page. With it off, the same Claude Code is refused with the reconnect message, the same token still reads `/api/v1`, and a browser-signed-in assistant is unaffected. Activity shows both changes.

**Implementation:** a setting (the existing settings pattern), read in `assistant/gate.py` before falling back to `user_from_bearer_token`. The refusal is a 401 that still carries the `resource_metadata` pointer, so clients that support it start the browser sign-in on their own. The developer setups this affects: this checkout's own `~/.claude.json` connects to staging with a token. Move it to browser sign-in in COM-1648 before staging's switch is turned off.

**On the chain:** migration (setting) + API.