---
id: 01M59MVADP1ZQ71GYS8YR8KYTK
created: 2026-10-19T08:36:01.078189Z
updated: 2026-10-19T08:36:05.068538Z
type: task
title: Write up on a post-incident review opens the review form instead of "This part of the page couldn't be shown"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1113
sprint: serbigk
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Sprint 76 fix-forward. Found by Steve smoke-testing staging, 2026-10-19.

## What happens

On an incident whose post-incident review has been started, clicking **Write up** replaces the review card with "This part of the page couldn't be shown — Something went wrong while drawing it." The review can't be written, so the incident can't be closed where a review is required (P1/P2, Privacy, AI).

## Likely cause (from reading the code; not yet confirmed on staging)

The write-up form's **Who took part** picker lists colleagues **by name**. The picker (Mantine `TagsInput`) throws if two options are the same: "Duplicate options are not supported". Staging very probably has two active accounts with the same display name (e.g. a local admin and the SSO account for the same person). The crash happens as the form first draws, so it fails before anything is typed.

`app/frontend/src/incidents/IncidentReviewCard.tsx` → `WriteUpModal`: `data={people.map((p) => p.name)}`. The same name→id map (`known`) also means two same-named colleagues can't be told apart, so the saved participant could be the wrong person.

**Confirm first:** reproduce in a Vitest test with a directory holding two users of the same name, and check staging's active users for duplicate names. If neither reproduces it, take the browser console error from Steve and fix what it shows.

## Fix

- The picker lists each colleague once, keyed by who they are, not their name. Same-named colleagues are told apart (job title, or sign-in name). Typing a free-text name for someone outside Compass still works.
- Saved participants keep the right person.
- Check the other incident pickers that list colleagues by name for the same fault.
- Test: the write-up form opens with duplicate names in the directory and saves the chosen person.

**Done when:** Write up opens the form on staging, and a review can be saved and completed with participants chosen from the list.