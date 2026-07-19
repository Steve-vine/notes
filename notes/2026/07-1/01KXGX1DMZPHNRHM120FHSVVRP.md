---
id: 01KXGX1DMZPHNRHM120FHSVVRP
created: 2026-07-14T18:08:16.031195529Z
updated: 2026-07-19T21:30:31.123262175Z
type: task
title: Templated content publish button
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 146
sprint: ssdk92z
comments:
- id: 01KXGX1NHXBN7E279D25CH8QTF
  author: Steve Vine
  at: 2026-07-14T18:08:24.125101157Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-07-03 17:05 UTC]
    Fixed: https://github.com/Steve-vine/compass/pull/138 (stacked on #137).

    Root cause: the button compared the body against `published_body`, but for a published item with no version snapshot (the seeded policy shells) `published_body` falls back to the working body — so they can never differ and Publish stays ghosted after any edit. Title/heading-only edits also never re-armed it (they don't change the body rollup). The detail API now returns a server-computed `has_unpublished_changes` comparing title/body/sections against the latest version snapshot, and the button + draft-changes alert use that.
assignee: steve
task_status: done
priority: medium
---
After editing `templated` content, the `publish` button doesn't become accessible, it remains ghosted.

---
*Migrated from Linear [DEV-792](https://linear.app/stevevine/issue/DEV-792/templated-content-publish-button) · created 2026-07-03 · completed 2026-07-03*