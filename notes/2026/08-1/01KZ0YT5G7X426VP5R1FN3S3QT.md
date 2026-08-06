---
id: 01KZ0YT5G7X426VP5R1FN3S3QT
created: 2026-08-02T10:02:48.199673Z
updated: 2026-08-06T08:15:43.36724Z
type: task
title: Integration-level default tags (the missing third tagging pattern)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 475
sprint: s7j0986
comments:
- id: 01KZ1ESE1XFBVEF3DJA27ER9J0
  author: Steve Vine
  at: 2026-08-02T14:42:01.405478Z
  text: |-
    Built and up for review — PR #414 (feature/ise-475-integration-default-tags), merged to staging. No migration (System.config, the ADR 0044 shape).

    - Default tags ride everything the integration contributes: entities at discovery and signals at ingest, asserted through the integration's OWN slice — provenance honest, per-integration set-replacement intact (change the defaults, the next sync moves the slice, no ghosts).
    - Tag-blind reports get the defaults as a floor ON TOP of what the slice already asserts — the ISE-204 protection preserved, pinned by test.
    - The Freshservice case works: register-less tickets streaming in as signals now carry the defaults and are reachable by ISE's vocabulary.
    - GET/PUT /systems/{id}/default-tags (admin write, audited, normalised through the pool's own parser — keys fold, values keep case — capped at 10). Default tags card on the integration's own page.
    - 6 new integration tests + 72-test regression green. NOTE: local full-suite frontend runs are unreliable while CI runs — the runners share this host (load avg 46 during PR CI); PR CI is the verdict.
assignee: steve
priority: medium
task_status: done
---
Tags reach ISE three ways and the third does not exist:

1. **Harvested from the source** — AWS, Azure, Kubernetes resources carry their own.
2. **Asserted per entry at registration** — the registers (Status Pages, Documents, Repos).
3. **Integration-level defaults** — "everything this integration contributes carries these tags." **Missing for every integration** (verified 2026-08-02: no such concept anywhere in the codebase).

The case that needs it is **Freshservice**. There is no register — tickets stream in continuously and become signals, which inherit the ticket's own arbitrary Freshservice tags. There is nothing to tag at entry, so per-entry tagging cannot serve it.

- Default tags configured on the integration, applied to everything it contributes (entities where it is a source of record, and signals).
- Asserted through that integration's own tag slice, so provenance stays honest and set-replacement still works per integration.
- Also gives any **tag-blind source** a floor rather than nothing.

**UI**: on the integration's own page — consistent with the Sprint 40 through-line that per-integration configuration lives on the page of the integration that owns it.

**Acceptance**: an operator can set default tags on an integration and see them on what it contributes, attributed to that integration; Freshservice signals become reachable by tag.