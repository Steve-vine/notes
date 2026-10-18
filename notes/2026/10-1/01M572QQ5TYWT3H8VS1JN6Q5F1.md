---
id: 01M572QQ5TYWT3H8VS1JN6Q5F1
created: 2026-10-18T08:40:59.834415Z
updated: 2026-10-18T08:40:59.834415Z
type: task
title: An incident moves through contain, recover and review on a timeline that can't be rewritten — every step, decision and change with who and when, and the times that give its durations
assignee: steve
priority: high
label: feature
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1068
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on triage (COM-1067). It answers SOC 2 CC7.4/CC7.5, ISO A.5.26, HIPAA 164.308(a)(6)(ii), IMA.4, IMA.7 and IMA.14–16.

## What people see

**Stages**, moved by handlers: Investigating → **Contained** → **Recovered** → **In review** (→ Closed in the closure task).
- **Contained** asks what was done to limit it ("disabled the account, isolated the laptop") and when.
- **Recovered** asks when service or normal operation was restored and **who authorised recovery** (IMA.16: authorised, not assumed). For an Availability incident it also asks whether the cause was removed first (IMA.15).
- A stage can be skipped where it doesn't apply (an AI error has nothing to contain). The step records "not applicable" with a word of why.

**Timeline**: one chronological list on the incident.
- **Entries are added automatically** for report, triage, every stage move, severity or category change, owner change and link change.
- **Handlers add entries** with the time something happened, which may be earlier than now ("14:05 vendor confirmed the key was revoked"), and optional attachments.
- **Entries can't be edited or deleted.** "Correct" adds a new entry that points at the one it corrects, and the original is shown struck through, still readable.

**Key times** card: occurred, detected, aware, reported, triaged, contained, recovered, closed. Durations are worked out from them: **time to detect, to triage, to contain, to recover**. Gaps show as "not yet".

## Rules

- Stages only move forward, except by reopening.
- The timeline is the incident's comments thread; there's no separate one.

## Notes (technical)

- Append-only table. The API has no update/delete. A correction row carries `corrects_id`.
- System entries are written in the same transaction as the change.

**Done when:** stages record their facts; the timeline shows system and handler entries in time order; entries can only be corrected, never changed; durations show.