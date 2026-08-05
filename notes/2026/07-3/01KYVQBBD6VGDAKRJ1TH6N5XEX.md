---
id: 01KYVQBBD6VGDAKRJ1TH6N5XEX
created: 2026-07-31T09:16:10.534188Z
updated: 2026-08-05T19:02:21.616775Z
type: task
title: Reset collected data scope
project: 01KX671DATY39VW6GWK3M2T3DN
number: 397
sprint: sfv5yw0
comments:
- id: 01KYYA6QEYK5BF60Z12ECQADNK
  author: Steve Vine
  at: 2026-08-01T09:24:10.846469Z
  text: |-
    Built 2026-08-01 — PR #392, merged to staging (08bb963). No migration.

    All three categories now reset:

    - Events — WebhookEvent rows go; the registered webhook_source rows stay, because deleting them would revoke ingest URLs that senders outside ISE are already pointed at.
    - Playbooks — deleted with their efficacy history (playbook_feedback cascades). They are distilled from the incidents the reset deletes, so one that survives is a claim with nothing left behind it.
    - Tags — the root cause of "only the Status Page section shows any": only entity_tag and finding_tag cascade with their parents, so the tags carried by the KEPT registers (documents, repos, status pages) held the whole tag pool open. Deleting the pool takes every link with it via CASCADE on tag_id.

    Deliberately kept, and now pinned by tests: the Tag Dictionary (tag_key/tag_value) and the admin's tag rules. Rule predicates are plain strings rather than foreign keys, so rules outlive the pool they match on and re-materialise their groups on the next sync.

    Also corrected the modal copy, which promised "Playbooks and the audit trail" under Kept — that would now have been a lie.

    Gates: test_data_reset.py extended (real Postgres) and green; ruff, ruff format, mypy strict, npm run build, eslint, prettier, vitest all green.
assignee: steve
label: null
priority: medium
task_status: done
---
A few things are missing from the Reset collected data feature in Maintenance.  The following areas need to also be reset.
- Events
- Playbooks
- Tags (Only the Status Page sections shows any, the rest are empty).