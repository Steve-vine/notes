---
id: 01M6HRFCDRCBMMWK2X4DHKGAEY
created: 2026-11-03T22:29:01.496151Z
updated: 2026-11-04T05:23:28.292547Z
type: task
title: Polaris and secrets — MCP tools to list and read secrets, ask what's due or half-rotated, add one, record or confirm a rotation, and work the Discovered tab; never a value, because Compass holds none
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1580
sprint: sjrd5gz
blocked_by:
- 01M6HREQY849F5X4RK913AW8QV
assignee: steve
label:
- feature
priority: medium
task_status: active
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