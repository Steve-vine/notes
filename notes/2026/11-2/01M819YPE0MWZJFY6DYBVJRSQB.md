---
id: 01M819YPE0MWZJFY6DYBVJRSQB
created: 2026-11-22T09:38:47.360146Z
updated: 2026-11-22T09:38:52.147128Z
type: task
title: 'ADR 0167 — registers reach the rest of Compass: links between registers, an import that updates, Polaris, a workflow lookup, audit packs and the auditor portal'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2087
sprint: ssj8zkq
assignee: steve
label:
- brief
priority: high
task_status: active
---
Sprint "Registers - Phase 2". Records the second sprint ADR 0165 §11 and ADR 0166 §3 deferred, with Steve's answers of 2026-11-22.

## Steve's answers
- Workflows **read** a register only (a lookup, like a document's list). "Started by an entry changing" waits until Workflows gain record triggers generally (ADR 0155 §4 Later).
- Audit packs include registers **automatically, by control**: any register kept for a control in the pack's scope.
- The **auditor portal** joins this sprint. A register reaches an auditor only when someone **provides it to a request**, like evidence, as it stood on a chosen date. The Trust Centre does not join.

## Calls made in planning (listed in the ADR)
- A blank cell in an update import leaves the field as it is.
- Polaris gets its own area ("registers"), so there's a Copilot agent to set up. Making registers, changing fields and Mark as reviewed stay on screen.
- Restricted registers can't be chosen in a workflow; an audit pack includes one only if the person building it can open it.

## Done when
- `decisions/0167-*.md` merged.
- `brief/feature-set-and-phasing.md` §7a and `brief/data-model.md` Registers match.

Docs only. Independent.