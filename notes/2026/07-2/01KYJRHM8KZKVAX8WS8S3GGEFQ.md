---
id: 01KYJRHM8KZKVAX8WS8S3GGEFQ
created: 2026-07-27T21:43:54.899214Z
updated: 2026-08-07T09:40:51.78537Z
type: task
title: 'ADR 0056 + brief: Playbooks V2 — pre-approved NL playbooks in a structured envelope'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 342
order: 1.0
sprint: sf23rna
assignee: steve
label: null
priority: high
task_status: done
---
The decision record for the desk/engineer split. ADR 0056 amends **0017** (the approval unit moves from per-change to per-playbook, spent at publish by a second engineer), extends **0025** (interpreted execution is semi-supervised: a responder watches the run; nothing lights-out), reshapes **0029** (playbook = freeform NL body + structured envelope), and adds a rung to **0015**'s ladder (viewer < responder < operator).

**ADR must cover:** why prose-interpreted-by-AI beat a step DSL (the incident page vs MCP lesson: rigid grammar loses to bounded interpretation; a DSL is a program needing code review); the envelope as the real safety boundary (worst case = allowed ops × bound target, enumerable at publish, regardless of prose); T3 never desk-executable; deterministic validation predicates — the interpreter NEVER self-certifies success; transcripts as the audit artefact (non-determinism is accepted, replayable narrative not replayable execution); spend returns in-app for interpreted runs (bounded, human-triggered, cheap-model tier, own cap line); one format, two interpreters (in-app runner for the desk, Claude/MCP for engineers); learning loop must stay able to auto-draft (prose is what diagnoses already are).

**Rejected alternatives to record:** per-execution approval status quo (the toll the desk model exists to remove); guard/action/verify step grammar (reviewable but brittle, authoring cost, DSL creep); full workflow engine (Rundeck/StackStorm territory — if ever needed, playbook-as-code in a repo, not JSONB).

**Brief** (docs/briefs/playbooks-v2.md): envelope field-by-field, lifecycle states + publish/demotion rules, the responder experience end-to-end, interpreted-run mechanics, validation grammar (field + operator + literal against declared evidence payloads, publish-time validated).