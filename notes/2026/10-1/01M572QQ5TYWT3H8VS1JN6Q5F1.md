---
id: 01M572QQ5TYWT3H8VS1JN6Q5F1
created: 2026-10-18T08:40:59.834415Z
updated: 2026-10-18T11:51:42.282906Z
type: task
title: An incident moves through contain, recover and review on a timeline that can't be rewritten — every step, decision and change with who and when, and the times that give its durations
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1068
sprint: serbigk
blocked_by:
- 01M572QB9FVHQ0N87TD129J76A
comments:
- id: 01M57DMWDB5B0RYXEYH672G40W
  author: Steve Vine
  at: 2026-10-18T11:51:41.226964Z
  text: |-
    Done: merged in PR #1067.

    - A triaged incident has a **Response** card.
      - **Contained** records what was done to limit it, and when.
      - **Recovered** records when normal operation came back and **who authorised recovery**, either a colleague or a typed name. For Availability-type incidents it also asks whether the cause was removed first (Yes, No or Not known).
      - Any stage can be marked **Not applicable** with a reason, and the next stage opens. An AI error can skip containment, for example.
      - **Start review** moves the incident to In review. Stages only move forward.
    - The **Timeline** card lists everything in the order it happened: the report, triage, every stage move, severity, category and owner changes, and handlers' own entries. Each shows when, who, what, the reason and any files.
    - Handlers **Add entry** with the time it happened (which can be earlier than now) and optional files.
    - Entries can't be edited or deleted. **Correct** adds a new entry pointing at the original, which stays readable but struck through. Only handler-written entries can be corrected, once each.
    - **Key times** now shows contained, recovered and closed, plus time to detect, triage, contain and recover. Anything not yet reached says "Not yet".

    Choices made:
    - Time to contain and time to recover are counted from detection, and the card says so.
    - Edits to title, description or key times stay in History rather than on the timeline.
assignee: steve
label:
- feature
priority: high
task_status: review
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