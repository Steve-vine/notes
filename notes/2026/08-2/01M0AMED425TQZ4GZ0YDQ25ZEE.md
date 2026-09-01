---
id: 01M0AMED425TQZ4GZ0YDQ25ZEE
created: 2026-08-18T14:29:43.17022Z
updated: 2026-09-01T13:55:50.627027Z
type: task
title: Role matrix list — toggle to hide disabled roles
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 259
order: 2.8125
sprint: s5gwx0s
comments:
- id: 01M0BJ5GEZKFSXQ0DG9JTDDNA1
  author: Steve Vine
  at: 2026-08-18T23:09:08.959773Z
  text: |-
    Built and merged to main (PR #261, CI green).

    The matrix now hides disabled roles by default behind a "Show disabled" switch on the list header — the working view is active roles; retired ones are one click away, never gone. Filtering is a status param on GET /business-roles (server-side, so counts stay honest rather than client-slicing), the choice persists across navigation via the sessionStorage stored-filters pattern (compass.roles.filters), and disabled rows keep a muted presentation (reduced opacity + their status pill) when shown, so the two states never blur.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
The COM-238 disable-instead-of-delete pattern means retired business roles accumulate in the matrix list forever. Add a **hide-disabled toggle**:

* Toggle on the list header ("Show disabled" switch or segmented filter), **hiding disabled roles by default** — the working view is active roles; disabled ones are one click away, never gone (they stay reachable for audit and for re-enabling).
* Filter server-side (`status` param on the list endpoint) rather than client-slicing, so counts and pagination stay honest.
* Persist the choice (the local-storage pattern used by other list filters) so it survives navigation.
* Disabled rows, when shown, keep their muted/disabled presentation so the two states never blur.

Same screen family as COM-257/COM-258 — bundle into that pass if convenient. Refs: COM-238, ADR 0027/0028 (the disable pattern), 0022.