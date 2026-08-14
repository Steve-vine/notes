---
id: 01M00ZRYPZ8EH1TK99BG81JW95
created: 2026-08-14T20:35:18.87988Z
updated: 2026-08-14T20:55:48.383603Z
type: task
title: An operator can publish a desk playbook but cannot run one — the runner is responder-only
project: 01KX671DATY39VW6GWK3M2T3DN
number: 721
sprint: sevhjex
comments:
- id: 01M010YFCZXV29M57MQBX3TWWG
  author: Steve Vine
  at: 2026-08-14T20:55:48.383445Z
  text: |-
    DONE 2026-08-14 — PR #670, merged to main. Frontend only, no migration, **no permission change** (as specified — `trigger_playbook_run` is responder-tier and already let an operator through).

    **One runner, two mounts.** Extracted to `components/PlaybookRunnerPanel.tsx` and mounted from both pages rather than reimplemented. The states — in flight, running, verdict, abort, resolve-on-green — are facts about the *run*, not about who is watching it. Only the copy differs, and only where it names who to escalate TO: telling an operator to "escalate to a DevOps engineer" is telling them to escalate to themselves.

    **It went inside the existing Playbooks section**, not beside it. That section (ISE-701) already answers "is there a procedure" — a second block elsewhere on the page would be a second answer to one question. A published playbook is in *both* the recall matches and the desk-runnable set, so it is shown once, in the list with the Run button, and the rest are labelled "Also matching, but not published desk-executable".

    Two things the mount surfaced that were not in the task:

    - **A collapsed section cannot learn from its children whether it should have opened.** My first attempt had the panel report its runnable ids upward; with no recall matches the section looked empty, started closed, never rendered the panel, and so never learned there was something runnable — permanently collapsed. The runnable query is now asked *by* the section (same React Query key, no second request). This is the ISE-702 lesson in a new shape: resolve the open default at render, never from the empty first render.
    - **`none_published` now counts as non-empty.** A playbook that matches perfectly and was never published is ISE's own configuration with a fix the reader can make right now — and it is *precisely* what happened on staging when this bug was found. Collapsing that to "No data" hides the one sentence they need. `IncidentSection`'s own docstring already says a section whose empty state can be acted on is not empty; this is that case.

    The responder's guided page is unchanged and its four existing test files pass untouched — which is the point: the fix widens who can reach the runner, it does not alter what the runner does. Four new tests cover the operator path, including that a published playbook is not listed twice.

    **ISE-715 step 3 is unblocked.**
assignee: steve
label:
- bug
priority: high
task_status: active
tech: null
---
Found trying to complete ISE-715 step 3 on staging, 2026-08-14: the Karpenter playbook was authored, its envelope validated and it was published desk-executable — and there is no way to run it from an operator's screen.

**Cause.** `GuidedIncidentView` is the only surface that fetches `desk-playbooks` and posts a run, and `IssueDetailPage.tsx:1979` gates it:

```tsx
if (hasRole(currentUser, 'responder') && !hasRole(currentUser, 'operator')) {
  return <GuidedIncidentView issue={issue} />
}
```

A responder who is *not* an operator gets the guided page. An operator or admin falls through to the full incident page — Analyse, Diagnose, Propose remediation, Ask Assist — which has no desk-playbook runner anywhere on it. So the person who authors and publishes a playbook is the one person who cannot run it.

That is ADR 0056's rung working as written: the desk surface was built for the Service Desk, and an operator was assumed to want the power tools instead. The assumption does not survive contact — running a published playbook is not a lesser tool, it is *the* tool, and an operator needs it more than anyone while a playbook is new.

**Wanted:** anyone with desk permissions **and above** can run a published playbook. Responder, operator, admin.

**Scope**
- Surface the desk-playbook runner on the operator's incident page, not only on the guided page. Reuse `GuidedIncidentView`'s panel rather than building a second one — one runner, one set of states, or the two will drift.
- Include the run states that already exist there: in-flight, the abort control (`abort-playbook-run`), and the verdict on completion.
- The API already permits it — `trigger_playbook_run` (`issues.py:1412`) re-checks `match_playbooks` and `desk_state == desk_executable` and is responder-tier, so operators and admins already pass. **This is a UI gap only**; no permission change is needed, and none should be made.
- Check the same gap on the guided side: a responder should keep exactly what they have.

**Why it blocks more than ISE-715.** Efficacy is earned from runs, and autonomy (ISE-714) is gated on efficacy. If the only account that can run a playbook is a responder-only one, then in a single-operator estate no playbook can accumulate a track record at all — and the autonomy gate can never open. This is on the critical path for the whole chain, not a convenience.

Blocks ISE-715. Related: ISE-714.