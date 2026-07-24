---
id: 01KY6YWBC43XC5461KTQBMQ4SW
created: 2026-07-23T07:43:44.51648Z
updated: 2026-07-24T14:48:58.17854Z
type: task
title: DataDog ignore rules — drop alerts matching configured tag values at ingest
project: 01KX671DATY39VW6GWK3M2T3DN
number: 227
sprint: sohzsw2
comments:
- id: 01KY71TGBPHM82GHKV0DWRNPBY
  author: Steve Vine
  at: 2026-07-23T08:35:09.814194Z
  text: |-
    Implemented and in review — PR #209 (feature/ise-227-datadog-ignore-rules → main).

    Approach:
    - ADR 0044 — ingest-time ignore rules, the first pre-ingest mute (distinct from per-signal silence/ignore and observation suppression).
    - Generic system.config JSONB (migration 0048); ignore_rules is its first tenant. A rule is a {key, value} tag equality; the set is an OR of case-insensitive exact matches against the alert's own tag set (monitor + scope tags, ADR 0037 §2).
    - Filter in the DataDog connector's detect: matched alerts are dropped before findings are created. Existing findings recover naturally on the next sync as they fall out of the batch (no teardown).
    - API: GET/PUT /systems/{id}/ignore-rules (admin write, viewer read, audited) + POST .../preview counting current open alerts a candidate rule set would hide.
    - UI: an "Ignore rules" card on the integration screen (alerts-capable systems) — add/remove, a "these rules hide N alerts" summary, and a per-rule "would hide N" guardrail as the rule is typed.

    Design note on the motivating case: those private-location alerts had EMPTY monitor tags, so tag rules alone won't catch them — the honest fix there is to tag the monitors in DataDog (or scope the group), which then makes them addressable here. ADR 0044 §6 records this and defers name/query/mute-status matching. Worth confirming during smoke test whether tagging those monitors is acceptable, or whether we want a follow-up for name/mute-status predicates.

    Tests: pure matching unit tests; connector detect drop/keep/case/scope; end-to-end sync (drop + recover-on-next-sync); API contract (round-trip, canonicalise+dedupe, RBAC, audit, preview). Backend ruff/mypy + frontend build/lint/vitest all green; API types regenerated.
assignee: steve
priority: medium
task_status: done
---
Let an operator define explicit ignore rules on the DataDog integration so alerts carrying configured tag values (e.g. `testing:true`, `env:dev`) are never surfaced as signals.

**Motivation (2026-07-23):** five `[Synthetic Private Locations] stopped reporting` groups (sandbox/staging/decommissioned-cluster locations) sat triggered in ISE — real in DataDog's monitor API but muted/hidden in the DD UI, so pure noise in the pane of glass. Today the only levers are per-finding silence or muting in DataDog itself; there is no "this class of alert is not our concern" rule.

**Scope sketch:**
- Ignore rules on the DataDog integration config: list of tag `key:value` predicates (start simple — OR of exact matches), matched against monitor tags / group tags at ingest in `_monitor_findings()`.
- Matched alerts are dropped before findings are created (not ingested-then-silenced); existing open findings that match a new rule get recovered/cleaned on next sync.
- **UI (the deliverable):** manage ignore rules on the DataDog integration screen (Settings → Integrations), showing rule list + add/remove; ideally a "would currently ignore N alerts" preview so a bad rule is visible before it hides real pages.
- Design note: the motivating private-location alerts had **empty** monitor tags — worth deciding whether rules can also match monitor name/query or mute-status, or whether the answer there is tagging the monitors in DD. Also decide interplay with existing silence/suppression concepts (ADR 0038) — likely a short ADR or an amendment.