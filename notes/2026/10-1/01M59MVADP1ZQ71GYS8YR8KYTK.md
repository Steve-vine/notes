---
id: 01M59MVADP1ZQ71GYS8YR8KYTK
created: 2026-10-19T08:36:01.078189Z
updated: 2026-10-19T08:42:40.782526Z
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

## Cause (confirmed on staging 2026-10-19)

The write-up form's **Who took part** picker lists colleagues **by name**. The picker (Mantine `TagsInput`) throws "Duplicate options are not supported" if two options are the same, and it fails as the form first draws.

Staging has two **active** accounts named **Steve Vine**:
- Entra sign-in, moneypenny.co.uk, no job title, created 2026-08-18;
- local password, stevevine.uk, "Head of Everything", created 2026-07-05.

Both are in the colleague directory, so the name appears twice. Any organisation where two people share a name, or one person has a local and an SSO account, hits this.

`app/frontend/src/incidents/IncidentReviewCard.tsx` → `WriteUpModal`: `data={people.map((p) => p.name)}`. Its name→id map (`known`) also can't tell same-named colleagues apart, so a saved participant could be the wrong account.

## Fix

- The picker lists each colleague once, keyed by who they are, not their name.
- Same-named colleagues are told apart by their sign-in (email). Job title is blank on one of the accounts here, so it isn't enough on its own.
- Typing a free-text name for someone outside Compass still works.
- Saved participants keep the right account. A participant already saved by name still shows.
- Check the other pickers in Incidents that list colleagues by name for the same fault (any `TagsInput`/`Select` whose options are names).
- Test: the write-up form opens with two same-named colleagues in the directory, and saves the one chosen.

**Done when:** Write up opens the form on staging (with both Steve Vine accounts still present), and a review can be saved and completed with participants chosen from the list.