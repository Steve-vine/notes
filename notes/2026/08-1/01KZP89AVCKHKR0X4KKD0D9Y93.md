---
id: 01KZP89AVCKHKR0X4KKD0D9Y93
created: 2026-08-10T16:32:25.452135Z
updated: 2026-08-11T18:38:54.188066Z
type: task
title: A change ISE cannot execute is drafted and approved before anything mentions the missing write credential
project: 01KX671DATY39VW6GWK3M2T3DN
number: 645
sprint: s1rgnyx
comments:
- id: 01KZRB0Z93CVYS8V9BW4J3KRN5
  author: Steve Vine
  at: 2026-08-11T11:58:46.051147Z
  text: |-
    PR #595 (stacked on #594). Acceptance met at both stages, with the executor's exact wording.

    `write_access(system)` is now the single answer, and the three surfaces read from it: the catalogue (so the agent knows before it drafts), the Approvals screen (so the approver knows before deciding), and the executor (which keeps enforcement). A guard that phrases itself differently at each stage teaches an operator that they are three separate rules, so the sentence is shared verbatim rather than re-written per surface.

    **Two deliberate non-changes, both from the "Consider" in the body.**

    I did **not** refuse at `propose_change`. Hiding the operations produces "no action available" and loses the diagnosis — the most valuable thing the run produced. The tool docstring now tells the agent to draft the change *and* state the obstacle: "the fix is X, but ISE has no write credential for this system" is a useful answer, and silence is not.

    I also did **not** gate the approve button. The banner informs; the executor decides. Refusing the approval would move the refusal rather than make it visible, and would take away the approver's ability to say "yes — and go and grant the credential", which is a perfectly reasonable thing for them to mean.

    Fails closed throughout, per the body's instruction to mirror `ActionsPanel`: an unregistered connector answers "no". One extra guard I added while there — `_read` takes a **required** session rather than an optional one, because an optional one would default the flag to "yes, it will run" for any caller that forgot to pass it, failing open on precisely the fact this exists to surface.

    The Servers exemption is preserved through `credential_use().write`, as the body noted it must be.

    **The operational half is untouched and still yours**: the seven enabled systems that declare actions and hold no write credential. That is a decision about what ISE is permitted to change in production, not a defect — and it is now visible in the app rather than discovered at execution, which was the point.
assignee: steve
label:
- improvement
priority: high
task_status: done
---
Found 2026-08-10 walking the resolution end of the Service Desk path. The write-credential guard is correct, well-reasoned and clearly worded — it just fires at the last possible moment.

**The sequence today**: the AI drafts a change → an approver approves it → execution refuses it. `tasks/actions/execute.py:115`:

> "<system> has no write credential configured, so ISE cannot change it. Add one in Settings to allow remediation."

Right message, three steps too late. An AI run was spent, an approver's judgement was spent, and the incident is no further forward.

**Neither earlier stage knows.**
- `get_action_catalogue` (`ai/tools.py:730`) returns every declared operation with its schema, tier and reversibility, and says nothing about whether this system can be written to at all. The agent drafts changes ISE has no licence to perform.
- `ApprovalsPage.tsx` never references the target system's write capability — the approver is shown an approvable change with nothing to distinguish it from an executable one.

**The app already knows how to say this.** `ActionsPanel` gates the manual Run buttons on `uses_write_credential` + `write_credential_ref` and shows "Read-only" (ISE-628, and it fails closed when the field is absent). The capability is modelled and rendered correctly where a human clicks Run, and is missing from both stages of the AI-driven path.

**Scope**
- `get_action_catalogue` states whether the system can execute. Preferably it still lists the operations — the agent should be able to say "the fix is X, but ISE has no write credential for this system" — rather than hiding them, which would produce "no action available" and lose the diagnosis. Failing closed on an absent field, as ActionsPanel does.
- The approvals surface marks a change whose target cannot be written to, before the approve button.
- Consider refusing at `propose_change` (`api/v1/proposed_changes.py:105`) rather than at execution — but only alongside the above, or the refusal simply moves rather than becoming visible.

**Acceptance**: a change against a system with no write credential is flagged as unexecutable at draft time and at approval time, with the same wording the executor already uses.

---

**Operational note — not code work.** These enabled systems declare actions but hold no write credential, so ISE cannot change them today (staging, 2026-08-10):

| System | Actions declared |
| --- | --- |
| CSP Softcat (azure) | 7 |
| datadog | 5 |
| env-staging-uk, env-staging-us, env-production-uk-pri, env-production-us-pri, mgnt-production-uk-pri (k8s) | 5 each |

Only `mgnt-staging-uk` of seven Kubernetes clusters can be acted on. Azure's gap is already known — ISE-386's MySQL restart needs a write-SP RBAC grant to execute. Granting these is a decision about what ISE is permitted to change in production, not a defect: **Steve's call, per system.** Servers is deliberately absent from this list — its credentials are per-target and `execute.py:114` exempts it via `credential_use().write`.