---
id: 01M1VJA817B264P8G2DZBHDXAH
created: 2026-09-06T14:35:16.903498Z
updated: 2026-09-06T14:35:20.322643Z
type: task
title: a new risk is born already treated — residual defaults below inherent, and can be set before anything has been done
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 590
sprint: s2fcksg
assignee: steve
label:
- improvement
priority: high
task_status: backlog
---
The New risk dialog defaults inherent likelihood and impact to **3 and 3**, and residual likelihood and impact to **2 and 2**.

That gap is an assertion, and it is not one anybody has made: a one-point reduction on both axes, before a single control has been named or a treatment recorded. Residual is the score the register bands, the heat-map plots and the appetite is judged against, so every risk enters the register already looking better than it is, and the reduction is invisible because nothing in the audit trail shows anyone claiming it — it was the form's opening position.

The dialog also lets residual be set freely while raising the risk, which offers the same claim as a deliberate act. At the moment a risk is raised there is nothing to reduce it: an untreated risk's residual *is* its inherent.

## What changes

- [ ] **Both pairs start equal.** Whatever the inherent default is, residual matches it. As the person raising the risk changes inherent, residual follows.
- [ ] **Residual is not editable while raising a risk.** Steve's call between removing the two fields and showing them disabled — recommend showing them, disabled and mirroring inherent, with a line saying residual starts equal to inherent and changes when a treatment is recorded. That teaches the model; removing the fields hides it, and the register's central distinction is one worth teaching at the moment somebody first meets it.
- [ ] **Enforce it in the API, not just the form** (ADR 0004 — the UI is one consumer). Make `residual_likelihood` / `residual_impact` optional on `RiskCreate`, defaulting to the inherent values. Any client creating a risk then gets an untreated one, and the rule cannot be bypassed by posting straight to the endpoint.
- [ ] Editing residual on the risk page is unchanged — that is where a reduction is recorded, after treatment, by somebody choosing to.

## Open question — the risks already raised

Every risk created before this carries the 2/2 default, so its recorded reduction is an artefact of the form. Worth deciding whether those are corrected to residual = inherent, or left alone as data somebody may since have reviewed. Not part of the fix; needs Steve's answer first, and if they are to be corrected, whether that is a one-off repair or a note to the risk owners to re-score.

## Related

- COM-581 — the cause/event/consequence statement this dialog now collects.
- COM-582 — treatment plans, the thing that is supposed to move residual.
- ADR 0012 — the risk model.
