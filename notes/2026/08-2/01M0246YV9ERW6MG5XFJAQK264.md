---
id: 01M0246YV9ERW6MG5XFJAQK264
created: 2026-08-15T07:12:06.505406Z
updated: 2026-08-15T07:12:13.138235Z
type: task
title: Nothing tells you the envelope exists — a new playbook is advisory and dead-ends there
project: 01KX671DATY39VW6GWK3M2T3DN
number: 725
sprint: sevhjex
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
tech: null
---
Authoring a playbook is a two-step flow and only the first step is signposted. Reported 2026-08-15, after the Karpenter playbook was created from the starter library and it was not obvious the same thing could be built by hand.

**What happens today.** `NewPlaybookModal` (`PlaybooksPage.tsx:190`) captures the prose half only — name, signal kind, likely causes, investigation plan, remediation options, validation criteria — and says so in a comment:

```
// V2 fields start empty from this modal — the envelope is built in
// the per-playbook editor (PlaybookDeskSection).
```

The success toast says *"It will surface in Recall on matching incidents"*, which is true and is the whole story as far as the operator can see. Nothing mentions that an envelope exists, that without one the playbook can never run, or that the place to build it is behind expanding that playbook on the Playbooks page.

**Nothing is missing from the editor.** `PlaybookDeskSection` exposes every field: `precondition` (with the closed estate-fact list), `validation` predicates (correctly barred from reading the estate), `wait` with anchor and seconds, `allowed_operations`, `target_scope`, `run_bounds`, `escalation_route`, and `outcome_on_pass` — which it derives, picking `record_and_resolve` automatically when the operation list is empty. So a hand-built equivalent of the Karpenter playbook is entirely possible. It is just unfindable.

This is the same shape as three gaps found on 2026-08-14 — the capability exists and the route to it does not (the entity-clear control that rendered only while there was no entity; the resolution note stored, audited and served but never displayed; the desk runner an operator cannot reach). Worth treating as a recurring failure mode rather than three coincidences.

**Scope** — pick one, not all three:
- Open the envelope editor straight after creation, so the two steps read as one flow; or
- Say it in the create modal and the toast: this playbook is advisory until it has an envelope, and here is where to add one; or
- Show it on the playbook itself — an advisory playbook with no envelope carries a visible "cannot run yet — add an envelope" state rather than looking finished.

The third is probably the most durable, since it also covers a playbook created months ago and forgotten, and it pairs naturally with ISE-723's work on showing a playbook's standing against the bar.

**Also worth deciding while here:** the "From library" button sits at the top level with exactly one entry in it. Its value is real but entirely in entries that do not exist yet. Either seed a few more estate-agnostic ones (a pod stuck Pending on resources, a certificate near expiry, a deployment whose replicas never converge) or fold it into the create flow as a "start from…" option until there is enough to browse.

Related: ISE-723 (a playbook shows its score but never the bar).