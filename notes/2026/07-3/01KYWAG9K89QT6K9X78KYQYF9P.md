---
id: 01KYWAG9K89QT6K9X78KYQYF9P
created: 2026-07-31T14:50:55.464811Z
updated: 2026-07-31T14:56:03.373774Z
type: task
title: 'Docs: Security — audit trail'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 432
order: 0.0078125
sprint: sp3en5k
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Replace the stub at `src/content/docs/security/audit.md` with real content: what the audit trail captures at each stage (proposed → approved → executed → outcome, plus who and against which target); AI run transcripts as audit artefacts; credential handling — encryption at rest, the key-encryption key, the per-integration read/write split, and secret redaction in logs; where to view audit history in the app; retention.

Ground in ADRs 0018, 0010 (structured logging + redaction), 0017, 0056. Operator audience, released capability only.