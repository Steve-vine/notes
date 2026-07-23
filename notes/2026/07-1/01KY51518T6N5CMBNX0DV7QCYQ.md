---
id: 01KY51518T6N5CMBNX0DV7QCYQ
created: 2026-07-22T13:44:57.370271Z
updated: 2026-07-23T19:50:29.666777Z
type: task
title: Tag Dictionary editor — Settings → Tags
project: 01KX671DATY39VW6GWK3M2T3DN
number: 212
sprint: s5khymf
blocked_by:
- 01KY514VRBX9E4E7V7Q7ZSWAND
comments:
- id: 01KY5BHGFW7FM2AG01G0GM6HGV
  author: Steve Vine
  at: 2026-07-22T16:46:31.932488Z
  text: |-
    Done — PR #197 (feature/ise-212-dictionary-editor), first of batch 2, stacked on the batch-1 chain.

    **Settings → Tag dictionary** (admin-gated, alongside the other admin tabs). Manages keys — name, description, `defined|open` mode, aliases, expected entity types — and the standard values under a defined key, each with its own synonyms. Add/edit/delete on all of it, as specified. Tab value is `tag-dictionary`; `tags` was already taken by Tag rules, as I flagged on ISE-211.

    **Descriptions treated as first-class**, per your note — the field's own description says they're read by the AI investigator as much as by people, so nobody fills them in as an afterthought.

    **Synchronous re-resolution, which turned out to be the load-bearing bit.** Every write re-resolves the whole pool and re-evaluates the tag rules before returning. Without it an edit only lands on a system's *next sync*, so an admin fixing an alias sees nothing change and reasonably concludes it didn't work. Two tests pin it: adding an alias changes the entity's badge immediately, and a canonically-written rule picks up its member the moment the synonym is added.

    **Delete semantics as specified** — mappings dissolve, pool rows are never touched, and the raw tags stand on their own again exactly as the estate reported them. The affected count is on the read model *and* in the delete tooltip ("N pool tags map through this — they will go back to their raw form, not be deleted"), so the warning is visible before the click rather than after.

    **One bug fixed at source while building this.** `tag_dictionary.load()` now uses `populate_existing`: a caller that has just edited a key holds it in the identity map with a stale `values` collection, and SQLAlchemy hands back the cached one — so the edit silently doesn't apply. That's exactly the path this editor takes, and it cost two failing tests to find. Worth knowing because any future caller that edits-then-resolves in one request would have hit it too.

    **One judgement call:** the list endpoint is viewer-readable while writes stay admin-only. The descriptions explain what the estate's tags *mean*, which is useful to everyone, and there's nothing sensitive in a vocabulary. Writes are admin as you specified.

    **Tests** — 9 backend integration (create/edit/read-back with lowercase folding, duplicate-name 409, unknown entity type 422, immediate re-resolution, group re-evaluation, delete dissolving mappings while pool rows survive, the affected count, value removal, every change audited) and 5 frontend covering the editor flows you asked for.

    Backend 942 passed, ruff + mypy strict clean; frontend 312 passed, lint/build clean; OpenAPI regenerated.
assignee: steve
label: null
priority: medium
task_status: done
---
Admin CRUD over the dictionary (Canon: "The Tag Dictionary" — "the dictionary is theirs, not shipped dogma").

- New Settings → Tags tab (admin-gated, alongside thresholds/spend): manage keys (name, description, `defined|open` mode, aliases, expected entity types) and defined values (value, description, aliases). Add/edit/delete on all of it.
- Descriptions are first-class — they feed the AI investigator's understanding of the vocabulary, not just tooltips.
- Every change audited; a mapping change triggers deterministic re-evaluation of rules/groups (reuse the `tag_rules.apply_rule` path).
- Deleting a key/value that has mapped pool tags: warn with the affected count; mappings dissolve back to raw (never delete pool rows).
- OpenAPI regen (`dump_openapi` + `npm run generate:api`); Vitest coverage for the editor flows.