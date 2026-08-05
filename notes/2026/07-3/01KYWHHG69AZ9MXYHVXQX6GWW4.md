---
id: 01KYWHHG69AZ9MXYHVXQX6GWW4
created: 2026-07-31T16:53:55.017933Z
updated: 2026-08-05T11:55:55.147085Z
type: task
title: Assignee routing — notify whoever owns the incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 449
order: 1.0
sprint: s8rg5n9
blocked_by:
- 01KYWHH9WKA1RDD2JCNXME42HK
assignee: steve
priority: medium
task_status: done
---
A channel can target a DYNAMIC recipient — "the incident's assignee" — rather than a fixed person or chat.

This is the capability that makes per-person delivery worth having: it is the difference between broadcasting into a room and telling the person who owns the problem. `Issue.assignee_id` already exists (→ User → email), and ISE-447 supplies email → aadObjectId → conversation.

- New destination mode on the channel alongside "this person" and "this group chat".
- Resolution happens at EMIT time (the assignee at the moment of the event), and the resolved recipient is recorded in the delivery payload snapshot — consistent with ADR 0067's rule that delivery never re-reads the subject.
- Unassigned incident → no recipient. Decide in build: skip silently, or fall back to a configured default recipient? Silently skipping a critical incident because nobody claimed it is the wrong failure mode, so a fallback is probably right.
- Events with no incident (`action_pending`, `integration_broken`) cannot resolve an assignee — such a channel should simply not match those events, and the UI should say so rather than letting someone configure a combination that can never fire.

Clean cut line: this is the task to drop if the sprint runs long — everything else works without it.