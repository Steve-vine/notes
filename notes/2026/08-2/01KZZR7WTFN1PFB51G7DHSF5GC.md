---
id: 01KZZR7WTFN1PFB51G7DHSF5GC
created: 2026-08-14T09:04:25.423567Z
updated: 2026-08-14T09:04:25.423567Z
type: task
title: Review the Learning panel — doubly gated, so nobody has ever seen it
label: improvement
priority: low
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 703
tech: null
---
Steve, 2026-08-14: *"Learning panel — I actually don't remember ever seeing this."*

There is a reason. `LearningPanel` (`IssueDetailPage.tsx`) refuses to render unless **both** conditions hold:

```
if (!terminal || !proposal) return null
```

`terminal` means the incident is `resolved` or `closed`, and `proposal` means the Update bookend actually produced a learning proposal for it. So it appears only on a finished incident that also generated something to learn — and until ISE-686 landed, bulk resolve was broken, so most incidents sat at `acknowledged` and never reached the first condition at all.

**What it is meant to be:** the back bookend of the Incident Loop (ISE-136, ADR 0029) — on a resolved incident ISE proposes what to learn, a playbook distilled from the fix plus the diagnosis, and a human confirms or edits it before anything is written. That is the mechanism by which ISE is supposed to get better at an incident it has seen before. A capability nobody has laid eyes on cannot be doing that job, and there is no way to tell from the outside whether it is proposing nothing, proposing badly, or never being reached.

**Scope — a review first, changes second**
- Establish whether proposals are actually being generated: how many resolved/closed incidents produced one, and how many were confirmed, edited or ignored. If the count is near zero the panel is not the problem.
- Decide what the section says when there is no proposal, now that ISE-699 makes it render on every incident regardless. "(No data)" on an open incident is honest but useless; "learning is proposed once this incident is resolved" tells the operator what to expect and when.
- Confirm the confirm/edit path still works end to end — it has had no exposure, so it has had no smoke testing either.

**Note the interaction with ISE-699/ISE-703's sibling work:** the panel is currently **yellow**, the colour Impact is taking. It needs a different one under the unique-colour rule; that allocation is owned by ISE-699.

Follows from the incident-page reshaping (ISE-699 onwards) but is a question about the feature, not the layout — the shell adoption happens there regardless of what this review concludes.