---
id: 01KY6YWBC43XC5461KTQBMQ4SW
created: 2026-07-23T07:43:44.51648Z
updated: 2026-07-23T08:17:22.879631Z
type: task
title: DataDog ignore rules — drop alerts matching configured tag values at ingest
project: 01KX671DATY39VW6GWK3M2T3DN
number: 227
sprint: sohzsw2
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Let an operator define explicit ignore rules on the DataDog integration so alerts carrying configured tag values (e.g. `testing:true`, `env:dev`) are never surfaced as signals.

**Motivation (2026-07-23):** five `[Synthetic Private Locations] stopped reporting` groups (sandbox/staging/decommissioned-cluster locations) sat triggered in ISE — real in DataDog's monitor API but muted/hidden in the DD UI, so pure noise in the pane of glass. Today the only levers are per-finding silence or muting in DataDog itself; there is no "this class of alert is not our concern" rule.

**Scope sketch:**
- Ignore rules on the DataDog integration config: list of tag `key:value` predicates (start simple — OR of exact matches), matched against monitor tags / group tags at ingest in `_monitor_findings()`.
- Matched alerts are dropped before findings are created (not ingested-then-silenced); existing open findings that match a new rule get recovered/cleaned on next sync.
- **UI (the deliverable):** manage ignore rules on the DataDog integration screen (Settings → Integrations), showing rule list + add/remove; ideally a "would currently ignore N alerts" preview so a bad rule is visible before it hides real pages.
- Design note: the motivating private-location alerts had **empty** monitor tags — worth deciding whether rules can also match monitor name/query or mute-status, or whether the answer there is tagging the monitors in DD. Also decide interplay with existing silence/suppression concepts (ADR 0038) — likely a short ADR or an amendment.