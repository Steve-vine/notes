---
id: 01KZDRNE6QVEXPCYQYJPPBX9XD
created: 2026-08-07T09:25:29.431993Z
updated: 2026-08-07T11:55:22.096858Z
type: task
title: Assist system prompt refresh — mission, freshness hierarchy, current tool surface
project: 01KX671DATY39VW6GWK3M2T3DN
number: 602
sprint: snk16ew
assignee: steve
priority: medium
task_status: backlog
---
Rewrite the Assist agent's system prompt (ai/assist.py) around the agreed mission: a read-only surface for estate questions — surfaces information, never acts, never offers to act.

- Freshness hierarchy: answer from synced state by default (watch `last_synced_at`), reach for live Evidence when the question says "right now" or the sync is stale — and always say which source the answer came from.
- Teach the current tool surface: identity entity types (user, app-registration, identity-group), the tag-search rule, estate query v2's predicates/counts, impact analysis for "what if X failed", documents/repos for "what does the doc say".
- Cross-integration synthesis is the job: encourage combining graph + state + evidence + documents for open questions, citing each source (`cite` before writing stays).
- Keep: reason only from tools, check list_proposed_changes before recommending anything is pending.

Verified by the question bank (ISE-595) on staging.