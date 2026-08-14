---
id: 01KZZR7WTFN1PFB51G7DHSF5GC
created: 2026-08-14T09:04:25.423567Z
updated: 2026-08-14T12:53:22.619258Z
type: task
title: Review the Learning panel — doubly gated, so nobody has ever seen it
project: 01KX671DATY39VW6GWK3M2T3DN
number: 703
sprint: sevhjex
comments:
- id: 01KZZXA643VPP4ZX7QCDXY4AK1
  author: Steve Vine
  at: 2026-08-14T10:33:03.363753Z
  text: |-
    REVIEW DONE + BUILT 2026-08-14 — PR #652 (open, backend job re-running after an unrelated flake; see below).

    THE REVIEW FIRST, as scoped. Measured against the staging database:

      143 terminal incidents (92 resolved, 51 closed); 135 of them have a signal
        0  with an executed fix
        5  with a diagnosis on record — only 2 of which ALSO have a signal
      → 2 of 143 would produce a proposal at all

    So the panel was never the problem. `propose_learning` needs an executed fix OR a diagnosis, and almost nothing has either — incidents are being resolved without a diagnosis on record. That bar is right, though: a playbook distilled from neither would be invented, not learned.

    THE CONFIRM PATH WORKS, and you HAVE used it: five `playbook_learned` audit rows, 2026-07-26, 07-27 (×2), 07-28 and 2026-08-05, all by you. Two of the resulting playbooks survive (three were deleted later). So "nobody has ever seen it" is really "it fires about twice a sprint and the last time was nine days ago". It had NO test, which is why "no exposure, so no smoke testing" was exactly right — it now has one that drives the whole path: render the proposal, edit the name, confirm, assert what was actually POSTed.

    WHAT THE SECTION SAYS WITH NO PROPOSAL — the decision you asked for, taken as "say WHICH, never a bare emptiness". `LearningResponse` gained a `reason`, so the screen can tell three different situations apart:
    - not_terminal → "ISE proposes what to learn once this incident is resolved or closed."
    - no_signal → "raised by hand, so there is no signal to key a playbook on — nothing will be proposed here." (never resolves itself)
    - nothing_to_distil → "closed with no diagnosis and no executed fix on record, so there is nothing durable to distil. Diagnosing before resolving is what gives ISE something to learn."
    The third is where 141 of 143 terminal incidents land, so what looked like a dead panel is actually a readable statement about how ISE is being worked.

    COLOUR: green, off Impact's yellow, per the ISE-699 allocation. The section now renders on every incident, and the `#learning` deep-link from Playbooks still resolves (the shell keeps the DOM id).

    WORTH A DECISION FROM YOU: the real finding is that 0 of 143 terminal incidents have an executed fix and only 5 have a diagnosis. The back bookend of the Incident Loop cannot learn anything from incidents that close without either. Raise a task on "diagnose before resolve" — a nudge in the resolve modal, or a resolve path that offers Diagnose first — if you want that chased.

    CI NOTE: this PR's backend job went red on `test_relevance_puts_what_you_typed_first`, which is nothing to do with it — an ISE-698 test that creates four entities in ONE transaction, so `created_at` (Postgres `now()` = the transaction clock) is identical across them and the `id desc` tiebreak decides the order. It fails whenever the cluster's random uuid sorts highest, about one run in four. Fixed in the ISE-704 branch (explicit timestamps) and re-run here.
assignee: steve
label:
- improvement
priority: low
task_status: done
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