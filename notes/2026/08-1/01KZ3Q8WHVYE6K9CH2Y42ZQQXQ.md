---
id: 01KZ3Q8WHVYE6K9CH2Y42ZQQXQ
created: 2026-08-03T11:48:45.243244Z
updated: 2026-08-07T23:34:55.475176Z
type: task
title: Alerts from a pack
project: 01KX671DATY39VW6GWK3M2T3DN
number: 504
sprint: s1mg25q
comments:
- id: 01KZF98S1M174ZETSZH65V6BFH
  author: Steve Vine
  at: 2026-08-07T23:34:54.77189Z
  text: |-
    Done — PR #539 (branch feature/ise-504-pack-alerts, stacked on #538). Closes the sprint.

    A pack's `alerts` mappings produce `FindingData`, and `detect()` hands them to the same reconcile → link → promote path every connector rides. Nothing downstream is pack-aware: severity overrides, ignore rules, the auto-incident threshold, correlation and recovery all behave exactly as they do for DataDog.

    **Alerts only, never Observations** — structurally, not by omission. An Observation carries ISE's own *confidence* about a source it is reasoning over; a pack forwards what its source states and has no judgement of its own to express (ADR 0094 §2). So `signal_type` is always `alert` and `confidence` is always `None`.

    **Ignore rules are applied in the connector**, where every other connector applies them (ADR 0044). A rule that worked for DataDog but not for a pack would be a rule an operator could not trust.

    Two mapping decisions, both about not losing a signal quietly:

    1. **An alert naming no entity gets `entity_key=None`**, not a bare `acme:widget:`. The prefix-not-applied-to-absent rule from ISE-503 matters most here: `acme:widget:` is a real key that resolves to a real workload, so the alternative isn't "no link", it's the *wrong* link — a signal attached to whichever entity happens to own that key.
    2. **Timestamps default forward, never backward.** A source stating no start time gets `now`, and `last_seen_at` falls back to `first_seen_at` (not to now — otherwise a stated start silently widens into a window reaching the present). Defaulting to the epoch would sort every such signal to the bottom of every view, which is a quieter way of losing it than dropping it would have been.

    Tests: 10 mapping/connector, plus 5 integration through the **real** `sync_one` against real Postgres — an alert becoming a signal joined to the entity the *same pack* discovered (both mappings mint the same key shape, which is the join), a critical signal opening a real Incident with `source=finding-promoted`, a pack alert the source stops reporting recovering on the next pass, ignore rules stopping an alert before it becomes a signal, and one pass satisfying both capabilities at once.

    Brief updated with the recovery semantics, which is the one thing a pack author can get wrong here and not notice: **presence is the contract** — filter the alert endpoint to the live set with `query`, or nothing ever recovers and every resolved incident in the source's history stays a live signal.
assignee: steve
label: null
priority: medium
task_status: review
---
Pack-declared alert mappings produce `FindingData` (source_key, severity mapping, entity_key resolution) through the normal `detect` → `reconcile_findings` → promotion path; ignore rules and severity caps apply server-side as for any connector. Done = a pack-defined integration's alerts flowing into Signals and Incidents in the UI.