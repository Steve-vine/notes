---
id: 01KY5RWJ7S9N8G1HCN8X522T2J
created: 2026-07-22T20:39:45.657478Z
updated: 2026-07-22T20:39:49.168306Z
type: task
title: Document extraction context — scope the entity list, allow unknown-entity proposals, widen the claim vocabulary
project: 01KX671DATY39VW6GWK3M2T3DN
number: 222
sprint: s5khymf
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
---
Follow-up from smoke-testing ISE-220 (2026-07-22). The extractor's *behaviour* was correct — it returned zero claims for the Kora triage runbook, which is procedural content, exactly as prompted ("a procedure, not a relationship"; "returning nothing is a correct answer"). But the transcript of that `extract-document-claims` run exposed three prompt/context defects:

1. **Scope the known-entities list.** The prompt currently dumps the entire estate (~350 names) including raw UUIDs, EC2 instance ids, and ephemeral GitLab-runner hostnames — token waste that makes "prefer these spellings" meaningless and grows with the estate. Replace with: the document's tag-linked entities + their graph neighbourhood (1–2 hops), excluding retired (ISE-206), ephemeral, and UUID/instance-id-named entities; include entity types alongside names.
2. **Soften the allow-list constraint.** "Do not claim anything about something not in this list" means a document can never teach ISE a new entity or alias — the opposite of the Document Register's purpose. Unknown names should be claimable as *entity/alias proposals* (the proposals queue is the safety net; ADR 0028 §3 candidate-match precedent). Keep the no-inference rules; relax only the anchoring.
3. **Widen the claim vocabulary.** Stated facts fell outside what claims can express: an explicit routing chain ("Cloudflare Tunnel → traefik → Service → pods" is a stated `routes-to` sequence) and a reporting alias ("test-us reports as service:openanswer"). Decide which of these claim kinds to support; don't widen into inference.

Evidence: the extract run at 2026-07-22 19:43 (agent run `extract-document-claims`, Kora — Common Failure Scenarios & Remediation) — read it before changing the prompt. Re-test against BOTH document shapes: the procedural runbook must still yield ~zero; the "Kora Infrastructure Overview" (statement-shaped) should yield anchored claims with citations.

Also noted from the same transcript, handled separately: Kora reports `env:live` (not `env:prod`) — dictionary alias decision, not part of this task.