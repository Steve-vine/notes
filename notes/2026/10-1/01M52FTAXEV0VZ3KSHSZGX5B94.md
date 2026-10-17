---
id: 01M52FTAXEV0VZ3KSHSZGX5B94
created: 2026-10-16T13:53:24.910485Z
updated: 2026-10-17T02:37:45.744502Z
type: task
title: The assistant can write discovery Rules — "always do this for resources like these", previewed first, put in order and applied now
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1031
sprint: sfzoxya
blocked_by:
- 01M52FSZS2RZE5QX196YJJQRXW
comments:
- id: 01M53VHWVK5ZKWE0STXGS1N8KE
  author: Steve Vine
  at: 2026-10-17T02:37:45.715394Z
  text: |-
    Done — merged to main (PR #1029). Goes to staging with the rest of sprints 73 and 74.

    What the assistant can now do, for a named company:
    - Read the rules in the order they're tried, each with what it matches, what it does, and how much it has filed (and if it's broken because its asset has gone).
    - Preview a rule — what awaiting a decision it would file right now — changing nothing.
    - Add a rule (matching on where found, kind, a tag and value, a name prefix, an OU, or what a server runs; then attach to an asset or discard with a reason).
    - Make a rule from resources "like these", the same way the screen does: their shared account, shared kind, and the first tag they all carry.
    - Change, move (1 = first) and delete rules; apply one now.
    Tested with the fake AWS account: the preview's count is exactly what applying files, and those resources show as attached to the asset. Changes show in Activity via assistant.

    My calls:
    - Saving a rule never files anything by itself; applying is a separate step that asks first, because it decides many resources at once (as the ADR says). So "save it and apply it" is two steps, with a question before the second.
    - A rule can be named by its number, or by words from the rule, its discard reason or its asset.
    - An OU is named by its name or path, read from the same list the rule editor uses (it holds OUs only, nothing secret).
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 74, MCP - Inventory (ADR in COM-1023). Built on COM-1030.

## What people can ask of it

- **Read (for a named company):** the rules in the order they apply. Each rule matches resources on where they were found, kind, a tag and its value, a name prefix, an OU, or what is known to run on them. It then either attaches them to a technology asset or discards them with a reason.
- **Write (whatever the person's role allows on screen):**
  - **preview** a rule: what's awaiting right now that it would file;
  - **add** a rule, optionally filing what it matches straight away;
  - **turn a set of resources into a rule**, as "Always do this for resources like these" does;
  - edit or delete a rule;
  - **reorder** the rules;
  - **apply one now.**
- **Example:** "Anything in the production account tagged app=payroll should go under AST-3. Show me what that would catch today, then save it and apply it."

## Notes (technical)

- Wraps `discovery_rules.py`: list, preview, POST (with `apply_now`), PUT, DELETE, reorder, and `/{id}/apply`.
- "Like these" builds the rule's match from the chosen resources, the way `DiscoveryRules.tsx` / the decision window does. Keep that logic in the tool, or call a route if one exists. Don't invent a new matching rule.
- The rule's target asset resolves through `find_asset`, and its "found in" through `find_connection` (COM-1030).
- Delete is `destructive`. Saving with `apply_now` files resources, so its description says so.
- New module `tools/inventory_rules.py`.
- Tests: the preview matches what the rule then files; writes are hidden without manage-register; a rule saved is recorded via assistant.

**Done when:** on staging, the assistant previews and saves a rule, applies it, and the matched resources move from Awaiting to Attached.