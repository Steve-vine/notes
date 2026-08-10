---
id: 01KZP772YXE4W1ZFC7VAAY3M78
created: 2026-08-10T16:13:43.261267Z
updated: 2026-08-10T19:03:18.316951Z
type: task
title: No playbook can become desk-executable — so the Service Desk path dead-ends on every incident
project: 01KX671DATY39VW6GWK3M2T3DN
number: 640
sprint: s1rgnyx
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found 2026-08-10 walking the Service Desk triage path. `GuidedIncidentView` shows "No pre-approved response for this incident — escalate to a DevOps engineer" for **every incident in the estate**, and will continue to no matter what anyone authors. The empty state is honest; it is just the only reachable state.

`/desk-playbooks` (`issues.py:1051`) filters matches to `desk_state == "desk_executable"`. Staging has **zero** such playbooks, and three independent things stop one existing:

**1. Both playbooks have an empty body.** `body_len = 0` on both rows. `PlaybookCreate.body` defaults to `""` (`playbooks_api.py:90`), so a playbook saves happily with no procedure prose — and `publish_desk` then refuses it: *"no body — the interpreter needs the procedure prose"* (`playbooks.py:147`). Nothing at authoring time says the thing you just saved can never run. The monitor_alert one has no envelope either, which is the second refusal.

**2. The author cannot publish their own playbook.** `playbooks.py:138` — separation of duties, ADR 0056: the publisher must not be `created_by`. Both playbooks were authored by `Steve.Vine@moneypenny.co.uk`.

**3. There is no second engineer.** The estate has exactly two users: `Steve.Vine@moneypenny.co.uk` and `break-glass@local`. So gate 2 is not merely unsatisfied, it is **unsatisfiable**.

## DECIDED 2026-08-10 — an admin may self-publish, audited distinctly

**ADR 0017 already answered this exact question** for change approval, and its reasoning transfers verbatim:

> "An `admin` MAY self-approve, because with a single human operator the alternative is that T3 changes cannot be approved at all; but it is audited *distinctly* as a self-approval, so it is visible rather than indistinguishable."

So `publish_desk` keeps the separation-of-duties gate for everyone below admin, and an admin publishing their own playbook records a **distinct audit action** (`playbook_self_published_desk` or equivalent) rather than the ordinary one. "Steve published Steve's playbook" becomes a visible fact in the record instead of an impossibility.

**Lands as an ADR 0056 amendment** — append a block, never rewrite the accepted decision.

**Rejected — break-glass as publisher of record.** A `BreakglassWindow` is scoped to one person, on one incident, for a bounded time (ADR 0089). Publishing a playbook is authoring-time and its effect is permanent, so the window's guarantees do not apply and using it would dilute what a breakglass audit row means.

**Rejected — an explicit single-operator mode.** New machinery for a case an existing ADR already answered, and it needs a defined transition for when a second engineer arrives.

**Still in scope, and the larger half of the work:**
- Authoring must state runnability: a playbook missing a body or a valid envelope says "not publishable — needs X" **on the playbook itself, at save**, not at the publish click. Reuse the preflight failure-category discipline — name the missing precondition.
- The publish gate should fail legibly, listing **every** unmet condition at once (body, envelope, separation of duties) rather than one 409 at a time.
- The two advisory playbooks have `efficacy_total = 0`, so `compute_tier` can never reach `rubber-stamp`. The advisory→published route wants to be a visible promotion path, not a separate authoring act.

**Acceptance**: an operator can get a playbook from authored to desk-executable in this deployment; a self-publish is distinguishable in the audit trail; a playbook that cannot be published says every reason why on its own page; the Service Desk sees at least one runnable response on an incident it matches.