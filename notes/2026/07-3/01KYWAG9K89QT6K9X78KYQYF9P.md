---
id: 01KYWAG9K89QT6K9X78KYQYF9P
created: 2026-07-31T14:50:55.464811Z
updated: 2026-08-07T10:09:34.274712Z
type: task
title: 'Docs: Security — audit trail'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 432
order: 0.0078125
sprint: sp3en5k
comments:
- id: 01KYWBMP2QZ6HBH8FA81Q0K7P4
  author: Steve Vine
  at: 2026-07-31T15:10:47.895091Z
  text: |-
    Done on feature/ise-432-docs-audit — PR #27, left OPEN for review.

    Full audit page: append-only framing; what's captured (sign-ins with break-glass highlighted, every proposed-change transition with actor/exact parameters/target/evidence links, role + integration + credential + risk-policy + model-config changes, AI runs, manual sync/analysis triggers, estate enrichment as a deliberately separate write class); how playbook transcripts read back (replayable narrative not replayable execution) and pre_approved_via provenance; self-approval flagged distinctly; where to look (Audit log filters + export, Agent runs as first-class "why did the AI say that" screen with model/tool-calls/tokens/artefacts, incident timeline merge). Credential handling in four parts: delivery (K8s Secrets only, nothing in git/values/images/CI logs, PR secret-scanning makes it a build failure not an incident), storage (envelope encryption, KEK delivered as deployment secret and NEVER in the DB, cross-link to the backup requirement, break-glass hash-only), exposure (write-only masked fields, redaction list extended per new integration), least privilege + read/write identity split + downtime-free rotation, and streamed redaction accumulated-and-scrubbed-whole. Facts from ADRs 0018/0010/0017/0056. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/security/audit.md` with real content: what the audit trail captures at each stage (proposed → approved → executed → outcome, plus who and against which target); AI run transcripts as audit artefacts; credential handling — encryption at rest, the key-encryption key, the per-integration read/write split, and secret redaction in logs; where to view audit history in the app; retention.

Ground in ADRs 0018, 0010 (structured logging + redaction), 0017, 0056. Operator audience, released capability only.