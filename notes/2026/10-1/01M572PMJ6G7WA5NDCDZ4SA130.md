---
id: 01M572PMJ6G7WA5NDCDZ4SA130
created: 2026-10-18T08:40:24.390363Z
updated: 2026-10-18T08:40:24.390363Z
type: task
title: Rubrics holds the notification obligations — who must be told, by when and from what moment, for which categories — shipped with UK GDPR and HIPAA
label: feature
priority: high
task_status: todo
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1065
---
Sprint 76, Incidents - Register (ADR in COM-1063). Builds on the Incidents card (COM-1064). It answers IMA.19, "obligations defined per obligation, with content, method, recipient and deadline".

## What people see

The Incidents card in Rubrics gains **Notification obligations**, a list someone can add to, edit, reorder and retire. Each obligation has:

- **Name**, e.g. "UK GDPR: tell the ICO".
- **Who is told**: Regulator, Affected individuals, Customer, Media, Business partner, Other, plus a free-text recipient (e.g. "Information Commissioner's Office").
- **Deadline**: a number of hours or days, or "without undue delay" (no fixed clock), or yearly by a date.
- **Counted from**: when the company became aware of the incident, or when it confirmed a breach.
- **Triggered by**: the categories it applies to.
- **When it applies**: plain words for the handler, e.g. "unless the breach is unlikely to result in a risk to people's rights and freedoms".
- **What to include and how**: guidance shown when the handler records it.

It ships with these, all editable:

| Obligation | Who | Deadline | Category |
|---|---|---|---|
| UK GDPR: tell the ICO | Regulator | 72 hours from awareness | Privacy |
| UK GDPR: tell the people affected | Individuals | Without undue delay, where high risk | Privacy |
| HIPAA: tell the individuals | Individuals | 60 days from discovery | Privacy |
| HIPAA: tell HHS, 500 or more affected | Regulator | 60 days from discovery | Privacy |
| HIPAA: HHS yearly log, under 500 | Regulator | Yearly, by 1 March | Privacy |
| HIPAA: tell the media, 500+ in one state | Media | 60 days from discovery | Privacy |
| HIPAA: business associate tells the covered entity | Business partner | 60 days from discovery | Privacy |
| Customer contract | Customer | Set per contract (placeholder, 24 hours) | Privacy, Security |

## Rules

- An obligation in use on an incident can't be deleted, only retired. Every edit is kept in its history.
- Changing a deadline doesn't move the deadlines on incidents already open. Each incident keeps the deadline it was given.

## Notes (technical)

- The HIPAA 500 threshold is guidance for the handler, not a calculation. The handler decides whether each obligation applies (COM notifications task).
- Snapshot the obligation's name, recipient and deadline onto each incident's notification row when it's triggered (vendor `prompt_snapshot` pattern).

**Done when:** obligations can be edited, retired and reordered; the seeds match the table; an obligation in use refuses deletion.