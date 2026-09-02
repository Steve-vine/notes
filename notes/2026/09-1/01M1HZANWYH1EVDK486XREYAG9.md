---
id: 01M1HZANWYH1EVDK486XREYAG9
created: 2026-09-02T21:10:18.270036Z
updated: 2026-09-02T21:10:24.109291Z
type: task
title: The auto-incident threshold now means something else, and still says the old thing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 770
sprint: s7nj09w
assignee: steve
label:
- tech_debt
priority: medium
task_status: backlog
tech: null
---
ADR 0110 changed what this setting decides without changing its value.

**Before:** the global threshold (default `high`, ADR 0026 §3) answered *"what opens an Incident?"*
**After:** it answers *"what counts as an impaired provider?"* (ADR 0109 §2). Whether an Incident opens is now the Correlator's judgement, from capability state and Business Criticality.

The number does not move and nothing breaks on adoption — which is exactly the risk. A setting that quietly starts meaning something else, while its label, help text and ADR reference still describe the old thing, is the failure mode this whole review kept finding: a fact about ISE's configuration, stated as a fact about the estate.

**In scope:** the Settings copy, `DEFAULT_THRESHOLD`'s comments in `severity.py`, the confidence bar beside it (same question — it now gates whether an Observation counts as impairing a provider), and anywhere the phrase "auto-incident" appears in a human-facing string.

**Names may stay.** `auto_incident_policy` and `DEFAULT_THRESHOLD` can keep their schema and code names under ADR 0103 — the domain object keeps its name, nothing a human reads does. This is a wording and documentation job, not a migration.

**Watch:** the table is empty today, so every install is running the default. Whatever the setting is renamed to must make sense to somebody who has never opened the screen.

**Blocked by** the Correlator (ISE-764) — reword when the meaning actually changes, not before.