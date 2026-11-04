---
id: 01M6HRFCDRCBMMWK2X4DHKGAEY
created: 2026-11-03T22:29:01.496151Z
updated: 2026-11-04T07:45:58.552039Z
type: task
title: Polaris and secrets — MCP tools to list and read secrets, ask what's due or half-rotated, add one, record or confirm a rotation, and work the Discovered tab; never a value, because Compass holds none
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1580
sprint: sjrd5gz
blocked_by:
- 01M6HREQY849F5X4RK913AW8QV
comments:
- id: 01M6JKDBSHJEA8CTJMXTS02ECC
  author: Steve Vine
  at: 2026-11-04T06:19:46.865704Z
  text: |-
    Merged to main in PR #1595.

    **What's in it**
    In Polaris (and over MCP), as the connected person and with their permissions, 14 `secrets_` tools:
    - **Reading:**
      - "what's overdue or due this month" (`secrets_whats_due`), with who owns each and what sets the date;
      - the register, filtered by owner, long-lived or name, oldest first (`secrets_list`);
      - one secret in full with its rotations (`secrets_get`);
      - rotations half done and what's left (`secrets_list_in_progress`);
      - Discovered, all or one store, with suggestions and keys at a source (`secrets_list_discovered`, `secrets_get_discovered`).
    - **Changing:**
      - add (`secrets_add`) and update (`secrets_update`);
      - make one from a Discovered copy (`secrets_make_from_discovered`), add a copy to a secret (`secrets_attach_store_entry`), and discard (`secrets_discard_discovered`);
      - record a rotation (`secrets_record_rotation`), confirm one (`secrets_confirm_rotation`), and mark a change as not a rotation (`secrets_mark_not_a_rotation`). Record and confirm ask first.
    - **Never a value:** text that looks like a key (`sk_live_…`) is refused, naming the field and never echoing the text. Polaris never offers to rotate anything. A rotation with the old key still working is refused.
    - Names and tags read from a cloud come back marked as cloud text, reported and never followed.
    - Viewers get the read tools. Add, make-from, attach and discard need Manage secrets.

    Tested by `test_assistant_secrets.py`.
- id: 01M6JQ0QTXRHT12TNR43CPCGJX
  author: Steve Vine
  at: 2026-11-04T07:22:47.516929Z
  text: |-
    **Pre-UAT: Passed, one item covered by tests only** (staging, through the Compass MCP connection as Steve, E2E Test Company only).
    - "What's overdue" (`secrets_whats_due`) named SEC-2, 35 days overdue, owned by E2E Admin A, set by its rotation interval.
    - Recording its rotation (`secrets_record_rotation`, old key revoked) moved next due to 4 Nov 2027.
    - A name containing a `sk_live_…` key was refused: "The name looks like a key or token. Compass never holds a secret's value…". The key wasn't echoed back.
    - **Couldn't check here:** the write tools refused as E2E Viewer, since my connection is Steve's own. `test_assistant_secrets.py` covers it: a viewer isn't offered the manage tools, and calling one is refused.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1579. It follows the MCP pattern from sprints 70–74: tools are auto-discovered, and each acts as the person who connected Polaris, with exactly their permissions.

## What people see

In Polaris (and over MCP), someone can ask:
- "Which secrets are overdue, or due this month?" and "Who owns the Stripe keys?"
- "Which rotations are half done, and what's left?"
- "Show me our long-lived secrets, oldest first." (Information only, as on screen.)
- "What's on the Discovered tab from AWS that isn't tracked yet?"
- "Make a secret from that entry, owned by Priya, used by billing-api."
- "I rotated SEC-12 today: the old key is revoked." (This records it.)
- "Confirm the rotation of SEC-4."

Polaris **refuses to accept a value**. If someone pastes one, the same guard as the screen (COM-1564) rejects it, and Polaris says why. It never offers to rotate anything, because Compass doesn't.

## Notes (technical)

- Tools (prefix `secrets_`):
  - `list`, `get`, `whats_due`, `list_in_progress`, `list_discovered`, `get_discovered`;
  - `add`, `update`, `make_from_discovered`, `attach_store_entry`, `discard_discovered`;
  - `record_rotation`, `confirm_rotation`, `mark_not_a_rotation`.
- Writes are annotated as such. Record and confirm say what will change before calling, per the server instructions.
- Cloud-read text (names, tags, descriptions) comes back under the untrusted-text marker, as Inventory's does (ADR 0113).
- Update the tool-count tests and the server instructions' module list. Add a Secrets paragraph alongside Inventory's.

**Chain:** on the chain (API: new MCP tools).

**Done when:** on staging, in E2E Test Company, through Polaris:
- "what's overdue" names the overdue test secret;
- recording a rotation for it moves its due date;
- pasting `sk_live_…` into a request is refused;
- as E2E Viewer, the write tools are refused.