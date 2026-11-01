---
id: 01M6B4ATHP6REAMVWQG45Q44ZK
created: 2026-11-01T08:41:34.006642Z
updated: 2026-11-01T13:01:12.560968Z
type: task
title: A document's review is one action, naming all its reviewers — not one row per reviewer
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1501
sprint: scpaa6p
comments:
- id: 01M6BK66X32JD20056A3XBPWDW
  author: Steve Vine
  at: 2026-11-01T13:01:11.45941Z
  text: |-
    Done: PR #1520 merged.
    - A document due for review is now one action, naming every active reviewer ("A, B"), and it's in My actions for each of them.
    - Mail is still per person, so each reviewer is emailed once inside the window (tested).
    - A document with no active reviewer goes to the type's default owner, as before.
    - Actions now carry the extra owners in a new co_owner_ids field. "Make the changes" rows were already one per document, and no other type lists one row per person for a single thing.
    - ADR 0137 amended.
    Pre-UAT after the staging deploy.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 100, Actions. Follows ADR 0137 (one action per thing). Steve decided on 1 Nov 2026 to make it one row.

## Why

A Playbook document (policy, standard, procedure, runbook) can name more than one reviewer. When its review comes due, Actions lists **one row per reviewer**, so it shows in each one's My actions. With My actions off, the same document is listed twice, which breaks "one action per thing". It's one review either way: either reviewer marking it reviewed clears every row.

## Behaviour

- A document whose review is due is **one** action. The Owner column names every reviewer ("Alex Smith, Sam Jones").
- It appears in **My actions** for each of its reviewers.
- Email is unchanged: each reviewer is still mailed inside the window. That's mail to every owner, not two actions.
- A document with no reviewers is unchanged: it goes to whoever the type's default owner is.
- "Make the changes" rows (a reviewer asked for changes) are unchanged. They're already one per document.
- Polaris's list of actions shows the same single row, with all the reviewers.
- If other action types turn out to have the same one-row-per-person pattern, list them in the PR, but don't change them here.

**Chain:** on the chain (an action can now carry more than one owner, which changes the API).

**Done when:**
- With My actions off, a document with two reviewers is listed once, naming both.
- With My actions on, it appears for each reviewer.
- Each reviewer is still emailed once inside the window.
- Marking it reviewed clears the row for both.
- Pre-UAT: the Playbook is shared, so nothing is published or reviewed on a real document. This is checked through the automated tests, and on screen against an existing two-reviewer document if staging has one. Otherwise it's marked "Couldn't check".