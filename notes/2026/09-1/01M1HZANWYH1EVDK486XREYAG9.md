---
id: 01M1HZANWYH1EVDK486XREYAG9
created: 2026-09-02T21:10:18.270036Z
updated: 2026-09-04T16:51:20.824446Z
type: task
title: The auto-incident threshold now means something else, and still says the old thing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 770
sprint: s7nj09w
comments:
- id: 01M1MHVWY1MWKDWDR7SMX8K5AR
  author: Steve Vine
  at: 2026-09-03T21:12:45.761626Z
  text: |-
    Built — PR #712 (feature/ise-770-threshold-wording). **No schema change**, exactly as the task called for.

    Auto-incident policy → **Impairment policy**. The threshold and the confidence bar are reworded to say what they now gate, and "auto-incident" is gone from everything a human reads: the Settings card, the severity-overrides card, the downgrade warning on an incident, `signal_decision`'s reason sentences, and the docstrings that reach the OpenAPI description.

    THE CARD SAYS THE CHANGE IN THE CARD
    Not in a release note nobody reads. One line under the title: this used to decide whether an Incident opened, it no longer does, and your setting is unchanged. An admin who set this last month would otherwise never learn it now decides something else — precisely because nothing broke. That is the risk the task named and it is the half that is easy to skip.

    NAMES STAY (ADR 0103)
    `auto_incident_policy`, `DEFAULT_THRESHOLD`, `should_auto_open` and the `/incident-policy` path are untouched. The domain object is the same row an admin has always edited, and renaming it would cost a migration to say something only a human needs told.

    ONE THING CHANGED MEANING, NOT JUST WORDS
    The downgrade warning. A downgrade below the threshold no longer stops an incident opening DIRECTLY — it stops the signal counting as a problem with the thing it landed on, which is the step that feeds everything above it. Saying the old thing would now be wrong rather than merely dated, so the warning was rewritten rather than relabelled.

    One thing to note for the future: the reworded docstrings reach the OpenAPI description, so the snapshot moved with them. The api-types gate caught it (commit 99882215) — worth remembering that a docs-only change to `severity_api.py` or `schemas.py` still needs `dump_openapi` + `generate:api`.
assignee: steve
label:
- tech_debt
priority: medium
task_status: done
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