---
id: 01M04ZDVQF7MYBNT7GE3WEAASJ
created: 2026-08-16T09:46:13.103157Z
updated: 2026-08-16T09:46:18.980839Z
type: task
title: 'Design: should a playbook be multi-cycle from the start?'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 738
sprint: skt3bzz
assignee: steve
label:
- brief
priority: high
task_status: backlog
tech: null
---
A design discussion to hold before ISE-711/712/714 build the single-cycle model. Opened 2026-08-16; parked while Sprint 64 continues.

## What prompted it

ADR 0101 settled on a deliberately fixed shape — **precondition → act → wait → validate → close | escalate** — chosen to keep a playbook enumerable at publish time and to stop it becoming a workflow language (ADR 0094's "no executable content EVER" is the neighbouring instinct).

The **second** real playbook anyone tried to write exceeded it. From IN-1360, a DataDog agent going quiet after a server reboot:

```
wait 10m → validate → pass: resolve
                    → fail: restart the DD Agent service
                            → wait 5m → validate → pass: resolve
                                                 → fail: escalate
```

Two act/wait/validate cycles with a branch between them. The Karpenter playbook (ISE-709/715) fitted the single-cycle shape only because its remediation was *nothing at all* — it concludes and resolves. The first playbook that actually changes something needed two cycles.

Steve, 2026-08-16: *"I can see multi-cycle workflows becoming a thing and maybe that's the right thing to focus on at this early stage rather than spending time tweaking the existing model and then re-write that later."*

## The question

Not "should we add a branch" but **what is the smallest model that covers real remediation without becoming a general workflow engine** — and is it cheaper to build that now than to build the single-cycle model and migrate published playbooks later.

## What the discussion has to settle

- **Depth.** Fixed at two cycles (try, then escalate), or N with a hard ceiling? A fixed depth stays enumerable; N invites loops.
- **What may branch.** Only on a validation outcome, or on arbitrary predicates? Only the first keeps the worst case readable at publish time, which is the property the whole prescriptive argument rests on.
- **Does it stay declarative?** Predicates are data today — field, operator, literal — and *"the interpreting model never certifies its own success."* Multi-cycle must not become the excuse to hand control flow to the model.
- **Publish-time enumerability.** ADR 0101 justified approving "a class of future changes" on the grounds the class is enumerable before the run. A branching playbook has more paths; the approver must still be able to read all of them.
- **Run bounds across cycles.** `run_bounds` and `wait` are per-run today. Two cycles with a 10-minute and a 5-minute wait is a run alive for a quarter of an hour that must remain abortable and visible (ISE-714).
- **Efficacy semantics.** A playbook that resolves on cycle one and one that resolves after remediating on cycle two are not equally strong evidence. ISE-722 already splits dismissals from fixes; multi-cycle adds a third shape.
- **Migration.** If ISE-711/712 land first, published envelopes exist in the single-cycle shape. Decide now whether they are forward-compatible or whether the sprint should pause.

## The live decision for Sprint 64

**ISE-711 and ISE-712 build the single-cycle envelope.** If multi-cycle is the target, some of that is rework — though not all: the precondition, the empty-operation outcome, predicate negation, `node_present`, the wait anchor and target binding are all needed either way. What would change is the *shape that contains them*.

Recommend continuing ISE-711/712 (the pieces are common to both) and holding **ISE-714** — the autonomy rung — until this is settled, since gating unattended execution on a model about to change is the expensive mistake.

## Worth carrying in

Three constraints found while trying to write the IN-1360 playbook, all real regardless of shape:
- `mpwxsqlclu02` is **not a registered server**, so no Ansible step could run against it; the only entity of that name is an EntraID app-registration. Estate coverage, not playbook work.
- `server_recent_logs` fails on Windows — *"Action 'ansible.windows.win_powershell' does not support raw params"*. `server_full_facts` carries `ansible_lastboot` and answers "did it reboot" better anyway.
- **"Has the alert recovered" is an ISE fact, not live evidence.** Preconditions may read the estate; validations may not, deliberately. For an alert-driven playbook that is the most natural validation there is, and today it cannot be expressed — compounded by ISE-729, since there is no DataDog service-check query either.

Related: ADR 0101 (ISE-710), ISE-711, ISE-712, ISE-714, ISE-715.