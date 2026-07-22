---
id: 01KXKWQMMYGNGQHE5RVMHBW1CY
created: 2026-07-15T22:00:38.814757576Z
updated: 2026-07-22T11:23:08.144006Z
type: task
title: Datadog event findings churn duplicate issues
project: 01KX671DATY39VW6GWK3M2T3DN
number: 82
sprint: syqgx3z
priority: high
task_status: done
---
The same Datadog condition spawns a new issue every sync — the queue fills with one open issue plus a long tail of near-identical resolved copies (e.g. "Percentage of unready Pods has been up for about 16 hours", drifting to "17 hours").

**Root cause:** Datadog event-stream findings key on a per-emission-unique event ID. `connectors/datadog.py:473` sets `source_key=f"event/{e.id}"`, but Datadog mints a fresh `e.id` each time it re-emits the same logical condition. Findings dedup on `(system_id, source_key)` (`models.py:172`), so each sync creates a NEW finding, auto-resolves the prior one (`sync.py:90-93`), and 1:1 promotion (`promotion.py:52-89`) mints a new open issue while resolving the previous one.

**Scope:** only the Datadog event path is affected. The monitor path (`monitor/{m.id}`) is stable, and Kubernetes already keys events semantically (`event/{namespace}/{kind}/{name}/{reason}`, `connectors/kubernetes.py:507`).

**Fix (code):** rekey Datadog event findings onto the stable underlying entity instead of the raw event ID — mirror the Kubernetes pattern (e.g. hash of alert_type/source/normalized-title/tags). Keep the time-varying "…N hours" text cosmetic in `title`/`details` only. Recurring re-emissions then collapse onto one finding, so upsert and promotion behave.

**Cleanup (data):** the existing tail of resolved duplicate issues won't clear on its own — needs a one-off tidy (identify the churned resolved Datadog issues and remove/collapse them). Decide on approach when implementing.